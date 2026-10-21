import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/pokemon.dart';
import '../state/nickname_notifier.dart';

/// Opens the nickname editor for [pokemon].
Future<void> showNicknameDialog(BuildContext context, Pokemon pokemon) {
  return showDialog<void>(
    context: context,
    builder: (_) => NicknameDialog(pokemon: pokemon),
  );
}

/// Text input with Save / Remove actions. A ConsumerStatefulWidget because it
/// owns a TextEditingController that has to be disposed.
class NicknameDialog extends ConsumerStatefulWidget {
  final Pokemon pokemon;

  const NicknameDialog({super.key, required this.pokemon});

  @override
  ConsumerState<NicknameDialog> createState() => _NicknameDialogState();
}

class _NicknameDialogState extends ConsumerState<NicknameDialog> {
  late final TextEditingController _controller;
  late final String? _currentNickname;

  @override
  void initState() {
    super.initState();
    _currentNickname =
        ref.read(nicknameProvider.notifier).nicknameFor(widget.pokemon.id);
    _controller = TextEditingController(text: _currentNickname ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    ref
        .read(nicknameProvider.notifier)
        .setNickname(widget.pokemon.id, _controller.text);
    Navigator.pop(context);
  }

  void _remove() {
    ref.read(nicknameProvider.notifier).removeNickname(widget.pokemon.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final hasNickname = _currentNickname != null;

    return AlertDialog(
      title: Text(hasNickname
          ? 'Edit nickname'
          : 'Nickname ${widget.pokemon.displayName}'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 20,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: 'Nickname',
          helperText: 'Original name: ${widget.pokemon.displayName}',
          border: const OutlineInputBorder(),
        ),
        onSubmitted: (_) => _save(),
      ),
      actions: [
        if (hasNickname)
          TextButton(
            onPressed: _remove,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
