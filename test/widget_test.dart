import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/services/pokemon.dart';
import 'package:flutter_application_1/state/favorites_notifier.dart';
import 'package:flutter_application_1/state/nickname_notifier.dart';
import 'package:flutter_application_1/state/pokemon_list_notifier.dart';
import 'package:flutter_application_1/state/type_filter_notifier.dart';

/// Replaces the API call with fixed data so the tests run offline.
class FakePokemonListNotifier extends PokemonListNotifier {
  @override
  Future<List<Pokemon>> build() async => const [
        Pokemon(id: 1, name: 'bulbasaur', imageUrl: '', types: ['grass', 'poison']),
        Pokemon(id: 4, name: 'charmander', imageUrl: '', types: ['fire']),
        Pokemon(id: 7, name: 'squirtle', imageUrl: '', types: ['water']),
      ];
}

ProviderContainer makeContainer() {
  final container = ProviderContainer(
    overrides: [
      pokemonListProvider.overrideWith(FakePokemonListNotifier.new),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('nickname can be set, edited and removed', () {
    final container = makeContainer();
    final nicknames = container.read(nicknameProvider.notifier);

    nicknames.setNickname(1, 'Bulby');
    expect(container.read(nicknameProvider)[1], 'Bulby');

    nicknames.setNickname(1, 'Seedy');
    expect(container.read(nicknameProvider)[1], 'Seedy');

    nicknames.removeNickname(1);
    expect(container.read(nicknameProvider).containsKey(1), isFalse);
  });

  test('toggling a favorite adds and removes it', () async {
    final container = makeContainer();
    await container.read(pokemonListProvider.future);
    final favorites = container.read(favoritesProvider.notifier);

    favorites.toggleFavorite(4);
    expect(container.read(favoritePokemonProvider).map((p) => p.id), [4]);

    favorites.toggleFavorite(4);
    expect(container.read(favoritePokemonProvider), isEmpty);
  });

  test('type filter shows only matching Pokémon and can be cleared', () async {
    final container = makeContainer();
    await container.read(pokemonListProvider.future);

    container.read(typeFilterProvider.notifier).selectType('fire');
    expect(
      container.read(filteredPokemonProvider).value!.map((p) => p.id),
      [4],
    );

    container.read(typeFilterProvider.notifier).clearFilter();
    expect(container.read(filteredPokemonProvider).value!.length, 3);
  });
}
