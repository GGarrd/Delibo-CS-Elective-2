import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/pokemon.dart';
import '../state/favorites_notifier.dart';
import '../state/nickname_notifier.dart';
import '../widgets/favorites_panel.dart';
import '../widgets/nickname_dialog.dart';
import '../widgets/type_chip.dart';

class PokemonDetailPage extends ConsumerWidget {
  final Pokemon pokemon;

  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nickname =
        ref.watch(nicknameProvider.select((map) => map[pokemon.id]));
    final isFavorite =
        ref.watch(favoritesProvider.select((ids) => ids.contains(pokemon.id)));

    return Scaffold(
      appBar: AppBar(
        title: Text(nickname ?? pokemon.displayName),
        centerTitle: true,
        actions: const [FavoritesPanelButton()],
      ),
      body: Column(
        children: [
          const FavoritesPanel(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ID: ${pokemon.displayId}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 220,
                          width: 220,
                          child: Image.network(
                            pokemon.imageUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image,
                                    size: 60, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (nickname != null) ...[
                          Text(
                            nickname,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            pokemon.displayName,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ] else
                          Text(
                            pokemon.displayName,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [
                            for (final type in pokemon.types)
                              TypeChip(type: type),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.edit),
                              label: Text(nickname == null
                                  ? 'Add nickname'
                                  : 'Edit nickname'),
                              onPressed: () =>
                                  showNicknameDialog(context, pokemon),
                            ),
                            FilledButton.tonalIcon(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null,
                              ),
                              label: Text(
                                  isFavorite ? 'Unfavorite' : 'Favorite'),
                              onPressed: () => ref
                                  .read(favoritesProvider.notifier)
                                  .toggleFavorite(pokemon.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
