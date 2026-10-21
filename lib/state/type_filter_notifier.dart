import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/pokemon.dart';
import 'pokemon_list_notifier.dart';

/// The selected type, or null when no filter is applied.
final typeFilterProvider = NotifierProvider<TypeFilterNotifier, String?>(
  TypeFilterNotifier.new,
);

class TypeFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void selectType(String type) => state = type;

  void clearFilter() => state = null;
}

/// Every type that appears in the loaded list, sorted, for the filter chips.
final availableTypesProvider = Provider<List<String>>((ref) {
  final allPokemon = ref.watch(pokemonListProvider).value ?? const [];
  final types = {for (final p in allPokemon) ...p.types}.toList()..sort();
  return types;
});

/// Derived provider: the list the grid shows. It combines the fetched list
/// with the selected type, keeping the loading/error states from the list.
final filteredPokemonProvider = Provider<AsyncValue<List<Pokemon>>>((ref) {
  final selectedType = ref.watch(typeFilterProvider);
  final asyncList = ref.watch(pokemonListProvider);

  if (selectedType == null) return asyncList;
  return asyncList.whenData(
    (list) => list.where((p) => p.types.contains(selectedType)).toList(),
  );
});
