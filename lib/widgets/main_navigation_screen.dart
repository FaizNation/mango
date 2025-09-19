
import 'package:flutter/material.dart';
import 'package:mango/screens/favorites/favorites_screen.dart';
import 'package:mango/screens/home/home_screen.dart';
import 'package:mango/screens/profile/profile_screen.dart';

import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  final String userEmail;
  final String userPass;
  const MainNavigationScreen({
    super.key,
    required this.userEmail,
    required this.userPass,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      MyHomePage(userEmail: widget.userEmail, userPass: widget.userPass),
      const FavoritesScreen(),
      ProfileScreen(userEmail: widget.userEmail, userPass: widget.userPass),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
            // selectedColor: Theme.of(context).primaryColor,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            // selectedColor: Colors.pink,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Profile'),
            // selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
