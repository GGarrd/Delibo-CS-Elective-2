import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/pokemon_provider.dart';

import 'page/pokedex_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PokemonProvider()..fetchPokemonList(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokéAPI Grid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
      ),
      // 3. Updated home to match your PokedexScreen class name
      home: const PokedexScreen(),
    );
  }
}