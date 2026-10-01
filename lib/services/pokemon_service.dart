import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

class PokemonService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  final http.Client _client;

  PokemonService({http.Client? client}) : _client = client ?? http.Client();

  /// One-shot request that yields a single result, so it returns a Future.
  Future<List<Pokemon>> fetchPokemon({int limit = 30}) async {
    final uri = Uri.parse('$_baseUrl?limit=$limit');
    final response =
        await _client.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Failed to load Pokémon (HTTP ${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final results = body['results'] as List<dynamic>;

    return results
        .map((e) => Pokemon.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
