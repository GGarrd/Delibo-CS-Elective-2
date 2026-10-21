import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../page/pokemon_detail_page.dart';
import '../services/pokemon.dart';
import '../state/favorites_notifier.dart';
import '../state/nickname_notifier.dart';
import 'nickname_dialog.dart';
import 'type_chip.dart';

class PokemonCard extends ConsumerWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // select() rebuilds this card only when ITS nickname or favorite status
    // changes, not when another Pokémon's does.
    final nickname =
        ref.watch(nicknameProvider.select((map) => map[pokemon.id]));
    final isFavorite =
        ref.watch(favoritesProvider.select((ids) => ids.contains(pokemon.id)));

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PokemonDetailPage(pokemon: pokemon),
          ),
        ),
        onLongPress: () => showNicknameDialog(context, pokemon),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    pokemon.displayId,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip:
                        isFavorite ? 'Remove from favorites' : 'Add to favorites',
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                    onPressed: () => ref
                        .read(favoritesProvider.notifier)
                        .toggleFavorite(pokemon.id),
                  ),
                ],
              ),
              Expanded(
                child: Image.network(
                  pokemon.imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                  errorBuilder: (context, error, stack) => const Center(
                    child:
                        Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Nickname (when set) on top, original name always shown.
              Text(
                nickname ?? pokemon.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (nickname != null)
                Text(
                  pokemon.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey[600]),
                ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: [
                  for (final type in pokemon.types)
                    TypeChip(type: type, small: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
