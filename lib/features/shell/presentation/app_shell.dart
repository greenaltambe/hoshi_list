import 'package:flutter/material.dart';
import 'package:hoshi_list/features/browse/presentation/browse_screen.dart';
import 'package:hoshi_list/features/home/presentation/home_screen.dart';
import 'package:hoshi_list/features/library/presentation/library_screen.dart';
import 'package:hoshi_list/features/profile/presentation/profile_screen.dart';
import 'package:hoshi_list/features/search/presentation/search_screen.dart';

class _Destination {
  const _Destination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.screen,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget screen;
}

/// The logged-in app: a bottom navigation bar over the four main screens.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _destinations = [
    _Destination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      screen: HomeScreen(),
    ),
    _Destination(
      label: 'Browse',
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
      screen: BrowseScreen(),
    ),
    _Destination(
      label: 'List',
      icon: Icons.list_alt,
      selectedIcon: Icons.list,
      screen: LibraryScreen(),
    ),
    _Destination(
      label: 'Profile',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      screen: ProfileScreen(),
    ),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_destinations[_index].label),
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SearchScreen())),
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: [for (final d in _destinations) d.screen],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: [
          for (final d in _destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: d.label,
            ),
        ],
      ),
    );
  }
}
