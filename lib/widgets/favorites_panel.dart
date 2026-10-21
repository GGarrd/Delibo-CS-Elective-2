import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../page/pokemon_detail_page.dart';
import '../state/favorites_notifier.dart';
import '../state/nickname_notifier.dart';

/// AppBar action that expands/collapses the favorites panel.
/// Shows a badge with the number of favorites.
class FavoritesPanelButton extends ConsumerWidget {
  const FavoritesPanelButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(favoritesPanelProvider);
    final count = ref.watch(favoritesProvider).length;

    return IconButton(
      tooltip: isExpanded ? 'Hide favorites' : 'Show favorites',
      onPressed: () => ref.read(favoritesPanelProvider.notifier).toggle(),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: Icon(isExpanded ? Icons.favorite : Icons.favorite_border),
      ),
    );
  }
}

/// Collapsible panel listing the favorite Pokémon. Placed at the top of every
/// page's body, so it can be opened and closed anywhere in the app.
class FavoritesPanel extends ConsumerWidget {
  const FavoritesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(favoritesPanelProvider);

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: isExpanded
          ? const _FavoritesPanelContent()
          : const SizedBox(width: double.infinity),
    );
  }
}

class _FavoritesPanelContent extends ConsumerWidget {
  const _FavoritesPanelContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritePokemonProvider);
    final nicknames = ref.watch(nicknameProvider);
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      color: colors.surfaceContainerHighest,
      padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Favorites (${favorites.length})',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Collapse',
                icon: const Icon(Icons.expand_less),
                onPressed: () =>
                    ref.read(favoritesPanelProvider.notifier).collapse(),
              ),
            ],
          ),
          if (favorites.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'No favorite Pokémon yet. Tap the heart on a card to add one.',
              ),
            )
          else
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: favorites.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final pokemon = favorites[index];
                  final nickname = nicknames[pokemon.id];

                  return SizedBox(
                    width: 84,
                    child: Stack(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PokemonDetailPage(pokemon: pokemon),
                            ),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  pokemon.imageUrl,
                                  errorBuilder: (_, _, _) =>
                                      const Icon(Icons.broken_image),
                                ),
                              ),
                              Text(
                                nickname ?? pokemon.displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            tooltip: 'Remove from favorites',
                            iconSize: 16,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 24,
                              minHeight: 24,
                            ),
                            icon: const Icon(Icons.close),
                            onPressed: () => ref
                                .read(favoritesProvider.notifier)
                                .removeFavorite(pokemon.id),
                          ),
                        ),
                      ],
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
