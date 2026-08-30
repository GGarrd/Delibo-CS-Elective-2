import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ── Responsive Breakpoints ────────────────────────────────────────────────────
const double kTabletBreak  = 600;
const double kDesktopBreak = 1024;

// ── Navigation item data ──────────────────────────────────────────────────────
class _NavItem {
  final String label;
  final IconData matIcon;
  final IconData cupIcon;
  const _NavItem(this.label, this.matIcon, this.cupIcon);
}

const _navItems = [
  _NavItem('Dashboard', Icons.home_rounded,     CupertinoIcons.house_fill),
  _NavItem('Settings',  Icons.settings_rounded, CupertinoIcons.settings),
  _NavItem('About',     Icons.info_rounded,     CupertinoIcons.info_circle_fill),
  _NavItem('Logout',    Icons.logout_rounded,   CupertinoIcons.square_arrow_right),
];

// ─────────────────────────────────────────────────────────────────────────────
//  DashboardScreen — top-level adaptive entry point
// ─────────────────────────────────────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  bool get _isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Widget build(BuildContext context) {
    return _isIOS ? _buildCupertinoLayout() : _buildMaterialLayout();
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  ADAPTIVE ▸ MATERIAL  (Android / Web)
  //  Uses LayoutBuilder to switch between Mobile / Tablet / Desktop layouts
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildMaterialLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;

        if (w >= kDesktopBreak) {
          // DESKTOP — permanent sidebar + main content + right panel
          return _DesktopScaffold(
            selectedIndex: _selectedIndex,
            onNavTap: (i) => setState(() => _selectedIndex = i),
          );
        } else {
          // MOBILE / TABLET — hamburger menu with slide-out drawer
          return _MobileTabletScaffold(
            selectedIndex: _selectedIndex,
            onNavTap: (i) => setState(() => _selectedIndex = i),
            isTablet: w >= kTabletBreak,
          );
        }
      },
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  ADAPTIVE ▸ CUPERTINO  (iOS)
  //  CupertinoTabScaffold + CupertinoTabBar replaces the Material drawer
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildCupertinoLayout() {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: _navItems
            .map((n) => BottomNavigationBarItem(
                  icon: Icon(n.cupIcon),
                  label: n.label,
                ))
            .toList(),
      ),
      tabBuilder: (context, index) => CupertinoTabView(
        builder: (_) => CupertinoPageScaffold(
          // CupertinoNavigationBar replaces Material AppBar on iOS
          navigationBar: CupertinoNavigationBar(
            middle: Text(_navItems[index].label),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (_, c) => _DashboardContent(
                columns:  c.maxWidth >= kTabletBreak ? 4 : 2,
                listRows: c.maxWidth >= kTabletBreak ? 6 : 3,
                isCupertino: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  DESKTOP SCAFFOLD  ≥ 1024 px
//  Layout: [Sidebar 200px] | [4-col grid + list rows] | [Right panel 180px]
// ─────────────────────────────────────────────────────────────────────────────
class _DesktopScaffold extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onNavTap;
  const _DesktopScaffold({required this.selectedIndex, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _DarkAppBar(showHamburger: false),
      body: Row(
        children: [
          // ── Permanent sidebar ──────────────────────────
          _Sidebar(selectedIndex: selectedIndex, onTap: onNavTap),

          // ── Main content + right panel ─────────────────
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Center: 4-col card grid + list rows
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                      const _CardGrid(columns: 4),
                      const SizedBox(height: 16),
                      ...List.generate(5, (_) => const _ListRow()),
                    ]),
                  ),
                ),

                // Right panel: large card + smaller card
                SizedBox(
                  width: 180,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                      _GreyBox(height: 220, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      _GreyBox(height: 160, color: Colors.grey[100]),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  MOBILE / TABLET SCAFFOLD  < 1024 px
//  Mobile (<600): hamburger + drawer + 2-col grid + 3 list rows
//  Tablet (600–1023): hamburger + drawer + 4-col grid + 6 list rows
// ─────────────────────────────────────────────────────────────────────────────
class _MobileTabletScaffold extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onNavTap;
  final bool isTablet;

  const _MobileTabletScaffold({
    required this.selectedIndex,
    required this.onNavTap,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _DarkAppBar(showHamburger: true),
      drawer: _NavDrawer(selectedIndex: selectedIndex, onTap: onNavTap),
      body: _DashboardContent(
        columns:  isTablet ? 4 : 2,
        listRows: isTablet ? 6 : 3,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  DARK APP BAR  (shared by desktop and mobile/tablet)
// ─────────────────────────────────────────────────────────────────────────────
class _DarkAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showHamburger;
  const _DarkAppBar({required this.showHamburger});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
      leading: showHamburger
          ? Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            )
          : null,
      title: const Text(
        'responsivedashboard',
        style: TextStyle(color: Colors.white, fontSize: 13),
      ),
      centerTitle: true,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SIDEBAR  (Desktop — always visible)
//  Heart logo + nav items with uppercase lettering
// ─────────────────────────────────────────────────────────────────────────────
class _Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const _Sidebar({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.grey[300],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: Icon(Icons.favorite, size: 40)),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          ...List.generate(_navItems.length, (i) {
            final item = _navItems[i];
            final selected = i == selectedIndex;
            return GestureDetector(
              onTap: () => onTap(i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: selected
                    ? BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(6),
                      )
                    : null,
                child: Row(
                  children: [
                    Icon(item.matIcon, size: 16),
                    const SizedBox(width: 10),
                    Text(
                      item.label.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  NAV DRAWER  (Mobile/Tablet — slides out from hamburger tap)
//  Heart logo + nav items — same structure as sidebar but in a Drawer
// ─────────────────────────────────────────────────────────────────────────────
class _NavDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const _NavDrawer({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Icon(Icons.favorite, size: 48)),
              const SizedBox(height: 32),
              ...List.generate(_navItems.length, (i) {
                final item = _navItems[i];
                return ListTile(
                  leading: Icon(item.matIcon, size: 18),
                  title: Text(
                    item.label.toUpperCase(),
                    style: const TextStyle(fontSize: 12, letterSpacing: 1.2),
                  ),
                  selected: i == selectedIndex,
                  onTap: () {
                    onTap(i);
                    Navigator.pop(context); // Close the drawer
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  DASHBOARD CONTENT  (shared by Mobile, Tablet, and iOS layouts)
//  Card grid + adaptive buttons + list rows
// ─────────────────────────────────────────────────────────────────────────────
class _DashboardContent extends StatelessWidget {
  final int columns;
  final int listRows;
  final bool isCupertino;

  const _DashboardContent({
    required this.columns,
    required this.listRows,
    this.isCupertino = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CardGrid(columns: columns),
          const SizedBox(height: 16),
          // Adaptive button section (Material vs Cupertino)
          _AdaptiveButtons(isCupertino: isCupertino),
          const SizedBox(height: 16),
          ...List.generate(listRows, (_) => const _ListRow()),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  CARD GRID  — always 4 cards, columns control layout (2-col or 4-col)
// ─────────────────────────────────────────────────────────────────────────────
class _CardGrid extends StatelessWidget {
  final int columns;
  const _CardGrid({required this.columns});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: columns,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: columns == 4 ? 1.2 : 1.0,
      children: List.generate(
        4, // Always 4 cards: 2×2 on mobile, 4×1 on tablet/desktop
        (_) => _GreyBox(color: Colors.grey[400]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  ADAPTIVE BUTTONS
//  Android/Web → Material ElevatedButton
//  iOS         → CupertinoButton.filled
// ─────────────────────────────────────────────────────────────────────────────
class _AdaptiveButtons extends StatelessWidget {
  final bool isCupertino;
  const _AdaptiveButtons({required this.isCupertino});

  @override
  Widget build(BuildContext context) {
    if (isCupertino) {
      // iOS: CupertinoButton with filled style
      return Row(
        children: [
          Expanded(
            child: CupertinoButton.filled(
              padding: const EdgeInsets.all(12),
              onPressed: () {},
              child: const Text('Click Me'),
            ),
          ),
          const SizedBox(width: 8),
          CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            onPressed: () {},
            child: const Icon(CupertinoIcons.heart_fill),
          ),
          const SizedBox(width: 8),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            onPressed: null, // Disabled
            child: const Text('Disabled'),
          ),
        ],
      );
    }

    // Android / Web: Material ElevatedButton
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A5568),
              foregroundColor: Colors.white,
            ),
            onPressed: () {},
            child: const Text('Click Me'),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A5568),
            foregroundColor: Colors.white,
          ),
          onPressed: () {},
          child: const Icon(Icons.favorite),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: null, // Disabled
          child: const Text('Disabled'),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SHARED PRIMITIVES
// ─────────────────────────────────────────────────────────────────────────────

/// Wireframe-style grey list row
class _ListRow extends StatelessWidget {
  const _ListRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
    );
  }
}

/// Wireframe-style grey box (cards and right-panel blocks)
class _GreyBox extends StatelessWidget {
  final double? height;
  final Color? color;
  const _GreyBox({this.height, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color ?? Colors.grey[400],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}