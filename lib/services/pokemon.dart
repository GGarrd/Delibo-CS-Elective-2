class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  String get displayId => '#${id.toString().padLeft(3, '0')}';

  String get displayName => name.isNotEmpty
      ? '${name[0].toUpperCase()}${name.substring(1)}'
      : name;

  factory Pokemon.fromApiJson(Map<String, dynamic> json) {
    final String url = json['url'] as String;
    // Extract ID from PokéAPI URL format: ".../pokemon/{id}/"
    final List<String> segments = url.trim().split('/').where((s) => s.isNotEmpty).toList();
    final int id = int.parse(segments.last);

    // Capitalize the first letter of the name for cleaner UI
    final String rawName = json['name'] as String;
    final String formattedName = rawName.isNotEmpty
        ? rawName[0].toUpperCase() + rawName.substring(1)
        : rawName;

    // Use official artwork sprite URL based on Pokemon ID
    final String imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

    return Pokemon(
      id: id,
      name: formattedName,
      imageUrl: imageUrl,
    );
  }
}
