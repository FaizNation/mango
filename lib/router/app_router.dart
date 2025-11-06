import 'package:mango/screens/auth/signin_screen.dart';
import 'package:mango/screens/auth/signup_screen.dart';
import 'package:mango/screens/getstarted_screen.dart';
import 'package:mango/screens/home/home_screen.dart';
import 'package:mango/screens/search/search_results_screen.dart';
import 'package:mango/screens/profile/profile_screen.dart';
import 'package:mango/screens/profile/change_password/change_password_screen.dart';
import 'package:mango/screens/profile/feedback/feedback_screen.dart';
import 'package:mango/screens/profile/about/about_screen.dart';
import 'package:mango/screens/favorites/favorites_screen.dart';
import 'package:mango/screens/history/history_screen.dart';
import 'package:mango/screens/splash_screen.dart';
import 'package:mango/widgets/main_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/search/:query',
      builder: (context, state) =>
          SearchResultsScreen(query: state.pathParameters['query'] ?? ''),
    ),
    // Auth routes
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/getstarted',
      name: 'getstarted',
      builder: (context, state) => const GetStartedPage(),
    ),
    GoRoute(
      path: '/',
      name: 'splashScreen',
      builder: (context, state) => const SplashScreen(),
    ),

    // Shell route for main navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainNavigationScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return MyHomePage(
                  userName: extra?['userName'] as String? ?? '',
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              builder: (context, state) => const FavoritesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return ProfileScreen(
                  userEmail: extra?['userEmail'] as String? ?? '',
                  userPass: extra?['userPass'] as String? ?? '', userName: '',
                );
              },
              routes: [
                GoRoute(
                  path: 'change-password',
                  builder: (context, state) => const ChangePasswordScreen(),
                ),
                GoRoute(
                  path: 'feedback',
                  builder: (context, state) => const FeedbackScreen(),
                ),
                GoRoute(
                  path: 'about',
                  builder: (context, state) => const AboutScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
