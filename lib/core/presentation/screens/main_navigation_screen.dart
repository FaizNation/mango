import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

// 1. Ubah menjadi StatelessWidget
class MainNavigationScreen extends StatelessWidget {
  
  // 2. Hapus parameter userEmail, userPass, dan userName.
  //    Widget "Shell" ini seharusnya tidak perlu tahu tentang data ini.
  //    Data ini akan diteruskan ke halaman (seperti ProfileScreen)
  //    oleh konfigurasi GoRouter Anda.
  
  final StatefulNavigationShell navigationShell;

  const MainNavigationScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 3. 'body' SEKARANG ADALAH navigationShell
      //    Ini adalah IndexedStack yang sudah dikelola oleh GoRouter.
      //    (Hapus: IndexedStack(index: _currentIndex, children: _screens))
      body: navigationShell,
      
      bottomNavigationBar: SalomonBottomBar(
        // 4. 'currentIndex' diambil dari navigationShell
        currentIndex: navigationShell.currentIndex,
        
        // 5. 'onTap' memanggil 'goBranch' untuk berpindah tab/halaman
        onTap: (index) => navigationShell.goBranch(index),
        
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite),
            title: const Text('Favorites'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.history),
            title: const Text('History'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Profile'),
          ),
        ],
      ),
    );
  }
}