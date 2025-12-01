import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mango/core/presentation/widgets/dialogs/exit_dialog.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainNavigationScreen extends StatelessWidget {
  
  final StatefulNavigationShell navigationShell;

  const MainNavigationScreen({
    super.key,
    required this.navigationShell,
  });

  bool _isOnRootTab(BuildContext context) {
    // Get current location from GoRouter
    final location = GoRouterState.of(context).uri.toString();
    
    // Root tabs are: /home, /favorites, /history, /profile
    final rootTabs = ['/home', '/favorites', '/history', '/profile'];
    
    return rootTabs.contains(location);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        // Only show exit dialog if on root tab
        if (_isOnRootTab(context)) {
          final confirm = await showExitConfirmationDialog(context);
          if (confirm && context.mounted) {
            SystemNavigator.pop();
          }
        } else {
          // If not on root tab, check if we can pop
          if (context.mounted) {
            final router = GoRouter.of(context);
            if (router.canPop()) {
              router.pop();
            }
            // If can't pop, do nothing (stay on current screen)
          }
        }
      },
      child: Scaffold(
        body: navigationShell,
        
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: navigationShell.currentIndex,
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
      ),
    );
  }
}