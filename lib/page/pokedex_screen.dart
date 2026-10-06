import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/pokemon_provider.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/state_message.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  @override
  void initState() {
    super.initState();
    // Safely trigger API request after initial widget tree finishes building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PokemonProvider>();
      if (provider.status == PokemonStatus.initial) {
        provider.fetchPokemonList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex (Top 30)'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              context.read<PokemonProvider>().fetchPokemonList();
            },
          ),
        ],
      ),
      body: Consumer<PokemonProvider>(
        builder: (context, provider, child) {
          if (provider.status == PokemonStatus.initial ||
              provider.status == PokemonStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.status == PokemonStatus.error) {
            return StateMessage(
              icon: Icons.error_outline,
              message: 'Error fetching data.\n${provider.errorMessage}',
              actionLabel: 'Retry',
              onAction: () => provider.fetchPokemonList(),
            );
          }

          if (provider.pokemonList.isEmpty) {
            return StateMessage(
              icon: Icons.catching_pokemon,
              message: 'No Pokémon found.',
              actionLabel: 'Refresh',
              onAction: () => provider.fetchPokemonList(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchPokemonList(),
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: provider.pokemonList.length,
              itemBuilder: (context, index) =>
                  PokemonCard(pokemon: provider.pokemonList[index]),
            ),
          );
        },
      ),
    );
  }
}