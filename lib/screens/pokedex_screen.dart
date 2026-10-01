import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/state_message.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  final PokemonService _service = PokemonService();
  late Future<List<Pokemon>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchPokemon(limit: 30);
  }

  void _retry() {
    setState(() {
      _future = _service.fetchPokemon(limit: 30);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex'), centerTitle: true),
      body: FutureBuilder<List<Pokemon>>(
        future: _future,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return StateMessage(
              icon: Icons.error_outline,
              message: 'Something went wrong.\n${snapshot.error}',
              actionLabel: 'Retry',
              onAction: _retry,
            );
          }

          // Empty
          final pokemon = snapshot.data ?? [];
          if (pokemon.isEmpty) {
            return StateMessage(
              icon: Icons.catching_pokemon,
              message: 'No Pokémon found.',
              actionLabel: 'Refresh',
              onAction: _retry,
            );
          }

          // Data: scrollable grid
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: pokemon.length,
            itemBuilder: (context, index) =>
                PokemonCard(pokemon: pokemon[index]),
          );
        },
      ),
    );
  }
}
