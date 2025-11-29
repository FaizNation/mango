import 'package:mango/core/router/comic/chapter_route.dart';
import 'package:mango/core/router/comic/comic_detail_route.dart';
import 'package:mango/features/auth/presentation/screens/signin_screen.dart';
import 'package:mango/features/auth/presentation/screens/signup_screen.dart';
import 'package:mango/features/profile/presentation/screens/about_screen.dart';
import 'package:mango/features/profile/presentation/screens/feedback_screen.dart';
import 'package:mango/features/onboarding/presentation/screens/getstarted_screen.dart';
import 'package:mango/features/home/domain/repositories/home_repository.dart';
import 'package:mango/features/home/domain/usecases/get_comics.dart';
import 'package:mango/features/home/domain/usecases/get_comics_by_type.dart';
import 'package:mango/features/home/presentation/cubit/home_cubit.dart';
import 'package:mango/features/home/presentation/screens/home_screen.dart';
import 'package:mango/features/search/presentation/screens/search_results_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/features/profile/domain/repositories/profile_repository.dart';
import 'package:mango/features/profile/domain/usecases/change_password.dart';
import 'package:mango/features/profile/domain/usecases/update_profile_photo.dart';
import 'package:mango/features/profile/presentation/cubit/change_password_cubit.dart';
import 'package:mango/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mango/features/profile/presentation/screens/profile_screen.dart';
import 'package:mango/features/profile/presentation/screens/change_password_screen.dart';
import 'package:mango/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:mango/features/favorites/domain/usecases/add_favorite.dart';
import 'package:mango/features/favorites/domain/usecases/get_favorites.dart';
import 'package:mango/features/favorites/domain/usecases/remove_favorite.dart';
import 'package:mango/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:mango/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:mango/features/history/domain/repositories/history_repository.dart';
import 'package:mango/features/history/domain/usecases/clear_all_history.dart';
import 'package:mango/features/history/domain/usecases/delete_history_entry.dart';
import 'package:mango/features/history/domain/usecases/get_history.dart';
import 'package:mango/features/history/presentation/cubit/history_cubit.dart';
import 'package:mango/features/history/presentation/screens/history_screen.dart';
import 'package:mango/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:mango/core/presentation/screens/main_navigation_screen.dart';
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

    // Comic detail by id
    GoRoute(
      path: '/comic/:comicId',
      name: 'comicDetail',
      builder: (context, state) {
        final comicId = state.pathParameters['comicId'] ?? '';
        return ComicDetailRoute(comicId: comicId);
      },
    ),

    // Chapter route: comic id + chapter id
    GoRoute(
      path: '/comic/:comicId/chapter/:chapterId',
      name: 'chapterDetail',
      builder: (context, state) {
        final comicId = state.pathParameters['comicId'] ?? '';
        final chapterId = state.pathParameters['chapterId'] ?? '';
        return ChapterRoute(comicId: comicId, chapterId: chapterId);
      },
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
                return BlocProvider(
                  create: (context) => HomeCubit(
                    getComics: GetComics(context.read<HomeRepository>()),
                    getComicsByType:
                        GetComicsByType(context.read<HomeRepository>()),
                  ),
                  child: const HomeScreen(),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              builder: (context, state) => BlocProvider(
                create: (context) => FavoritesCubit(
                  getFavorites: GetFavorites(context.read<FavoritesRepository>()),
                  addFavorite: AddFavorite(context.read<FavoritesRepository>()),
                  removeFavorite: RemoveFavorite(context.read<FavoritesRepository>()),
                ),
                child: const FavoritesScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => BlocProvider(
                create: (context) => HistoryCubit(
                  getHistory: GetHistory(context.read<HistoryRepository>()),
                  deleteHistoryEntry:
                      DeleteHistoryEntry(context.read<HistoryRepository>()),
                  clearAllHistory:
                      ClearAllHistory(context.read<HistoryRepository>()),
                ),
                child: const HistoryScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) {
                return BlocProvider(
                  create: (context) => ProfileCubit(
                    updateProfilePhoto: UpdateProfilePhoto(
                        context.read<ProfileRepository>()),
                  ),
                  child: const ProfileScreen(),
                );
              },
              routes: [
                GoRoute(
                  path: 'change-password',
                  builder: (context, state) => BlocProvider(
                    create: (context) => ChangePasswordCubit(
                      changePassword:
                          ChangePassword(context.read<ProfileRepository>()),
                    ),
                    child: const ChangePasswordScreen(),
                  ),
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
