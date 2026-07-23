import 'package:flutter/material.dart';

import 'create/create_screen.dart';
import 'home/home_screen.dart';
import 'sample_list/sample_list_screen.dart';

/// Top-level navigation shell. The MVP has exactly three destinations —
/// no login, no saved letters, no favorites — so the bottom bar is kept to
/// just what's actually implemented.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'ホーム',
    ),
    NavigationDestination(
      icon: Icon(Icons.menu_book_outlined),
      selectedIcon: Icon(Icons.menu_book),
      label: '文例',
    ),
    NavigationDestination(
      icon: Icon(Icons.edit_outlined),
      selectedIcon: Icon(Icons.edit),
      label: '作成',
    ),
  ];

  final _screens = const [
    HomeScreen(),
    SampleListScreen(),
    CreateScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: _destinations,
      ),
    );
  }
}
