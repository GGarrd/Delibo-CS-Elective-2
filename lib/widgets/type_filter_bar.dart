import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/type_filter_notifier.dart';
import 'type_chip.dart';

/// Horizontal row of chips: "All" clears the filter, the rest select a type.
/// The types come from the loaded Pokémon data, not a hardcoded list.
class TypeFilterBar extends ConsumerWidget {
  const TypeFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final types = ref.watch(availableTypesProvider);
    final selectedType = ref.watch(typeFilterProvider);
    final filter = ref.read(typeFilterProvider.notifier);

    if (types.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: selectedType == null,
            onSelected: (_) => filter.clearFilter(),
          ),
          for (final type in types) ...[
            const SizedBox(width: 8),
            ChoiceChip(
              label: Text(capitalize(type)),
              selected: selectedType == type,
              selectedColor: colorForType(type).withValues(alpha: 0.35),
              avatar: CircleAvatar(backgroundColor: colorForType(type)),
              onSelected: (isSelected) => isSelected
                  ? filter.selectType(type)
                  : filter.clearFilter(),
            ),
          ],
        ],
      ),
    );
  }
}
