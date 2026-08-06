import 'package:flutter/material.dart';

void main() {
  runApp(const StreamingApp());
}

class StreamingApp extends StatelessWidget {
  const StreamingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D12),
        fontFamily: 'Helvetica', // A standard clean sans-serif
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            const SizedBox(height: 10),
            _buildMyListSection(),
            const SizedBox(height: 100), // Padding for bottom nav
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        // Background Image
        Container(
          height: 600,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://static.wixstatic.com/media/eb8076_a3b7c665ccec48aa9849d5cb61fc2fcd~mv2.png/v1/fill/w_556,h_799,al_c,lg_1,q_90,enc_avif,quality_auto/eb8076_a3b7c665ccec48aa9849d5cb61fc2fcd~mv2.png', // Replace with my own image URL
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Gradient Overlay
        Container(
          height: 600,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF0D0D12).withOpacity(0.6),
                Colors.transparent,
                Colors.transparent,
                const Color(0xFF0D0D12).withOpacity(0.8),
                const Color(0xFF0D0D12),
              ],
              stops: const [0.0, 0.2, 0.6, 0.9, 1.0],
            ),
          ),
        ),
        // Top SafeArea Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar Area
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'For Debbie',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.cast, color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Category Chips
                Row(
                  children: [
                    _buildChip('TV Shows'),
                    const SizedBox(width: 12),
                    _buildChip('Movies'),

                    const Spacer(),

                    const SizedBox(width: 12),
                    _buildChip('Categories', hasDropdown: true),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Movie Details (Bottom of Hero)
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Atlas',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Science fiction • Actions',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    'N',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'MOVIE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Action Buttons
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow, size: 24),
                      label: const Text(
                        'Play',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, {bool hasDropdown = false, VoidCallback? onTap}) {
    return Material(
      color: const Color(0xFF6B4D3C).withOpacity(0.4), // Moved color here
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap ?? () {}, // Add your tap logic here
        borderRadius: BorderRadius.circular(20), // Matches the ripple to the border
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (hasDropdown) ...[
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My List',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: const [
                  Text(
                    'See all',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Icon(Icons.chevron_right, color: Colors.white70, size: 16),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _buildPoster('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5lhItLXsbhNnBEux6vysClAzwr2jwbl3KGK4O34deYw&s=10'),
              _buildPoster('https://m.media-amazon.com/images/M/MV5BNTc0YmQxMjEtODI5MC00NjFiLTlkMWUtOGQ5NjFmYWUyZGJhXkEyXkFqcGc@._V1_.jpg'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPoster(String imageUrl, {VoidCallback? onTap}) {
    return Container(
      width: 240,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias, // Ensures the ripple stays inside the rounded corners
        child: InkWell(
          onTap: onTap ?? () {}, 
          child: Ink.image(
            image: NetworkImage(imageUrl), // Use AssetImage if you switched to local files
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24).withOpacity(0.95), 
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Active Home Tab
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: () {}, // Home tap action
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: const [
                    Icon(Icons.home_filled, color: Colors.black, size: 20),
                    SizedBox(width: 6),
                    Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Inactive Tabs (Now responsive buttons)
          IconButton(
            icon: const Icon(Icons.explore_outlined, color: Colors.grey, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.ondemand_video, color: Colors.grey, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.yellow, size: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}