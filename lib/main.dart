import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Fruit dataset with visuals
final Map<String, Map<String, dynamic>> fruitData = {
  'apple': {'name': 'Apple', 'emoji': '🍎', 'color': Colors.redAccent},
  'banana': {'name': 'Banana', 'emoji': '🍌', 'color': Colors.amber},
  'cherry': {'name': 'Cherry', 'emoji': '🍒', 'color': Colors.pink},
  'mango': {'name': 'Mango', 'emoji': '🥭', 'color': Colors.orange},
  'orange': {'name': 'Orange', 'emoji': '🍊', 'color': Colors.deepOrange},
};

// 1. Router Setup with Sub-Routing
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const FruitListScreen(),
      routes: [
        // Nested sub-route resolving to '/fruit/:name'
        GoRoute(
          path: 'fruit/:name',
          builder: (context, state) {
            final nameParam = state.pathParameters['name'] ?? '';
            return FruitDetailScreen(fruitKey: nameParam.toLowerCase());
          },
        ),
      ],
    ),
  ],
);

void main() {
  runApp(const FruitApp());
}

class FruitApp extends StatelessWidget {
  const FruitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
    );
  }
}

// 2. Root Page: List of Fruits ('/')
class FruitListScreen extends StatelessWidget {
  const FruitListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fruits = fruitData.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruit Directory'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: fruits.length,
        itemBuilder: (context, index) {
          final key = fruits[index].key;
          final data = fruits[index].value;

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Text(data['emoji'], style: const TextStyle(fontSize: 32)),
              title: Text(
                data['name'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('/fruit/$key'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to nested route
                context.go('/fruit/$key');
              },
            ),
          );
        },
      ),
    );
  }
}

// 3. Detail Page: Fruit Illustration ('/fruit/:name')
class FruitDetailScreen extends StatelessWidget {
  final String fruitKey;

  const FruitDetailScreen({super.key, required this.fruitKey});

  @override
  Widget build(BuildContext context) {
    final fruit = fruitData[fruitKey];

    if (fruit == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Fruit not found!', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(fruit['name']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration Container
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: (fruit['color'] as Color).withValues(alpha:0.2),
                shape: BoxShape.circle,
                border: Border.all(color: fruit['color'], width: 4),
              ),
              child: Center(
                child: Text(
                  fruit['emoji'],
                  style: const TextStyle(fontSize: 100),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              fruit['name'],
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'URL: /fruit/$fruitKey',
                style: const TextStyle(fontFamily: 'monospace', color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}