import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/pokemon_list_notifier.dart';
import '../state/type_filter_notifier.dart';
import '../widgets/favorites_panel.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/state_message.dart';
import '../widgets/type_chip.dart';
import '../widgets/type_filter_bar.dart';

/// No initState fetch is needed anymore: watching pokemonListProvider
/// triggers the notifier's build(), which loads the list.
class PokedexScreen extends ConsumerWidget {
  const PokedexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPokemon = ref.watch(filteredPokemonProvider);
    final selectedType = ref.watch(typeFilterProvider);
    final isRefreshing = asyncPokemon.isLoading && asyncPokemon.hasValue;

    // Every refresh path calls the same fetch method on the notifier.
    Future<void> refresh() =>
        ref.read(pokemonListProvider.notifier).fetchPokemonList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex (Top 30)'),
        centerTitle: true,
        actions: [
          const FavoritesPanelButton(),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: refresh,
          ),
        ],
        bottom: isRefreshing
            ? const PreferredSize(
                preferredSize: Size.fromHeight(4),
                child: LinearProgressIndicator(),
              )
            : null,
      ),
      body: Column(
        children: [
          const FavoritesPanel(),
          const TypeFilterBar(),
          Expanded(
            child: asyncPokemon.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => StateMessage(
                icon: Icons.error_outline,
                message: 'Could not load Pokémon.\n'
                    'Check your internet connection and try again.\n\n$error',
                actionLabel: 'Retry',
                onAction: refresh,
              ),
              data: (pokemonList) {
                if (pokemonList.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: refresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 80),
                        StateMessage(
                          icon: Icons.catching_pokemon,
                          message: selectedType == null
                              ? 'No Pokémon found.'
                              : 'No ${capitalize(selectedType)}-type Pokémon in this list.',
                          actionLabel:
                              selectedType == null ? 'Refresh' : 'Clear filter',
                          onAction: selectedType == null
                              ? refresh
                              : () => ref
                                  .read(typeFilterProvider.notifier)
                                  .clearFilter(),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: refresh,
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: pokemonList.length,
                    itemBuilder: (context, index) =>
                        PokemonCard(pokemon: pokemonList[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
