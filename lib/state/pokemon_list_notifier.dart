import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../services/pokemon.dart';

/// Holds the Pokémon list as an AsyncValue, which already models the three
/// UI states the app needs: loading, data (success) and error.
final pokemonListProvider =
    AsyncNotifierProvider<PokemonListNotifier, List<Pokemon>>(
  PokemonListNotifier.new,
);

class PokemonListNotifier extends AsyncNotifier<List<Pokemon>> {
  static const int _limit = 30;
  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  /// Runs once, the first time a widget watches pokemonListProvider.
  /// Riverpod puts the provider in AsyncLoading while this Future runs,
  /// then AsyncData on success or AsyncError if it throws.
  @override
  Future<List<Pokemon>> build() => _loadFromApi();

  /// The fetch method. Used by the refresh button, pull-to-refresh and the
  /// Retry button on the error screen.
  Future<void> fetchPokemonList() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadFromApi);
  }

  Future<List<Pokemon>> _loadFromApi() async {
    final response = await http.get(Uri.parse('$_baseUrl?limit=$_limit'));
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load Pokémon. Status code: ${response.statusCode}');
    }

    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> results = data['results'];

    // The list endpoint has no types, so each Pokémon's detail is fetched
    // in parallel to get its real type data.
    final pokemon = await Future.wait(
      results.map((item) => _fetchDetail(item['url'] as String)),
    );
    return pokemon;
  }

  Future<Pokemon> _fetchDetail(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load Pokémon details. Status code: ${response.statusCode}');
    }
    return Pokemon.fromDetailJson(json.decode(response.body));
  }
}
