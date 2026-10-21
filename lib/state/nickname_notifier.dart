import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Nicknames keyed by Pokémon id. The original name stays on the Pokémon
/// model; this map only stores the custom name the user assigned.
final nicknameProvider = NotifierProvider<NicknameNotifier, Map<int, String>>(
  NicknameNotifier.new,
);

class NicknameNotifier extends Notifier<Map<int, String>> {
  @override
  Map<int, String> build() => {};

  /// Assigns or edits a nickname. A blank nickname counts as removing it.
  void setNickname(int pokemonId, String nickname) {
    final trimmed = nickname.trim();
    if (trimmed.isEmpty) {
      removeNickname(pokemonId);
      return;
    }
    // A new Map is assigned so Riverpod sees a changed state and rebuilds
    // every widget watching nicknames.
    state = {...state, pokemonId: trimmed};
  }

  void removeNickname(int pokemonId) {
    if (!state.containsKey(pokemonId)) return;
    state = Map.of(state)..remove(pokemonId);
  }

  String? nicknameFor(int pokemonId) => state[pokemonId];
}
