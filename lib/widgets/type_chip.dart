import 'package:flutter/material.dart';

const Map<String, Color> pokemonTypeColors = {
  'normal': Color(0xFFA8A77A),
  'fire': Color(0xFFEE8130),
  'water': Color(0xFF6390F0),
  'electric': Color(0xFFF7D02C),
  'grass': Color(0xFF7AC74C),
  'ice': Color(0xFF96D9D6),
  'fighting': Color(0xFFC22E28),
  'poison': Color(0xFFA33EA1),
  'ground': Color(0xFFE2BF65),
  'flying': Color(0xFFA98FF3),
  'psychic': Color(0xFFF95587),
  'bug': Color(0xFFA6B91A),
  'rock': Color(0xFFB6A136),
  'ghost': Color(0xFF735797),
  'dragon': Color(0xFF6F35FC),
  'dark': Color(0xFF705746),
  'steel': Color(0xFFB7B7CE),
  'fairy': Color(0xFFD685AD),
};

Color colorForType(String type) => pokemonTypeColors[type] ?? Colors.grey;

String capitalize(String value) =>
    value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';

/// Small read-only label showing a Pokémon type.
class TypeChip extends StatelessWidget {
  final String type;
  final bool small;

  const TypeChip({super.key, required this.type, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 10,
        vertical: small ? 1 : 4,
      ),
      decoration: BoxDecoration(
        color: colorForType(type),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        capitalize(type),
        style: TextStyle(
          color: Colors.white,
          fontSize: small ? 10 : 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
