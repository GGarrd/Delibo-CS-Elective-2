import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/pokemon.dart';
import 'pokemon_list_notifier.dart';

/// Ids of the Pokémon marked as favorites.
final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<int>>(
  FavoritesNotifier.new,
);

class FavoritesNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() => {};

  bool isFavorite(int pokemonId) => state.contains(pokemonId);

  void addFavorite(int pokemonId) {
    if (state.contains(pokemonId)) return;
    state = {...state, pokemonId};
  }

  void removeFavorite(int pokemonId) {
    if (!state.contains(pokemonId)) return;
    state = Set.of(state)..remove(pokemonId);
  }

  void toggleFavorite(int pokemonId) {
    isFavorite(pokemonId)
        ? removeFavorite(pokemonId)
        : addFavorite(pokemonId);
  }
}

/// Derived provider: the favorite Pokémon objects for the favorites panel.
/// It recomputes whenever the list or the favorite ids change, so the panel
/// updates immediately.
final favoritePokemonProvider = Provider<List<Pokemon>>((ref) {
  final favoriteIds = ref.watch(favoritesProvider);
  final allPokemon = ref.watch(pokemonListProvider).value ?? const [];
  return allPokemon.where((p) => favoriteIds.contains(p.id)).toList();
});

/// Whether the favorites panel is expanded. Kept in app state so the panel
/// stays open or closed as the user moves between screens.
final favoritesPanelProvider = NotifierProvider<FavoritesPanelNotifier, bool>(
  FavoritesPanelNotifier.new,
);

class FavoritesPanelNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
  void collapse() => state = false;
}
