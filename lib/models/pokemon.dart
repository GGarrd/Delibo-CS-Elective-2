class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  /// The list endpoint returns only `name` and `url`
  /// (e.g. https://pokeapi.co/api/v2/pokemon/25/), so the ID is parsed
  /// from the URL and the artwork URL is built from it.
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final segments = url.split('/').where((s) => s.isNotEmpty).toList();
    final id = int.parse(segments.last);

    return Pokemon(
      id: id,
      name: json['name'] as String,
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
    );
  }

  String get displayName =>
      name.isEmpty ? name : name[0].toUpperCase() + name.substring(1);

  String get displayId => '#${id.toString().padLeft(3, '0')}';
}
