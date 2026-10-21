class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;

  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
  });

  String get displayId => '#${id.toString().padLeft(3, '0')}';

  String get displayName => name.isNotEmpty
      ? '${name[0].toUpperCase()}${name.substring(1)}'
      : name;

  /// Builds a Pokémon from the detail endpoint: https://pokeapi.co/api/v2/pokemon/{id}
  /// The list endpoint only gives name + url, so the detail call is what
  /// provides the real type data used by the type filter.
  factory Pokemon.fromDetailJson(Map<String, dynamic> json) {
    final int id = json['id'] as int;
    final String rawName = json['name'] as String;

    final List<String> types = (json['types'] as List<dynamic>)
        .map((t) => (t['type']['name'] as String))
        .toList();

    final String imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

    return Pokemon(
      id: id,
      name: rawName,
      imageUrl: imageUrl,
      types: types,
    );
  }
}
