import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../services/pokemon.dart';

enum PokemonStatus { initial, loading, success, error }

class PokemonProvider extends ChangeNotifier {
  PokemonStatus _status = PokemonStatus.initial;
  List<Pokemon> _pokemonList = [];
  String _errorMessage = '';
  Pokemon? _selectedPokemon;

  // Getters
  PokemonStatus get status => _status;
  List<Pokemon> get pokemonList => _pokemonList;
  String get errorMessage => _errorMessage;
  Pokemon? get selectedPokemon => _selectedPokemon;

  // Set the selected Pokemon in App State before navigating
  void selectPokemon(Pokemon pokemon) {
    _selectedPokemon = pokemon;
    notifyListeners();
  }

  // API Call Method
  Future<void> fetchPokemonList() async {
    _status = PokemonStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final Uri uri = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=30');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        _pokemonList = results.map((item) => Pokemon.fromApiJson(item)).toList();
        _status = PokemonStatus.success;
      } else {
        _errorMessage = 'Failed to load Pokémon. Status code: ${response.statusCode}';
        _status = PokemonStatus.error;
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      _status = PokemonStatus.error;
    }

    notifyListeners();
  }
}