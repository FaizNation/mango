import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'core/config/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:mango/injection.dart';
import 'package:mango/core/network/api_client.dart';
import 'package:mango/features/auth/domain/repositories/auth_repository.dart';
import 'package:mango/features/profile/domain/repositories/profile_repository.dart';
import 'package:mango/features/home/domain/repositories/home_repository.dart';
import 'package:mango/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:mango/features/history/domain/repositories/history_repository.dart';
import 'package:mango/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mango/core/router/app_router.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // initialize service locator
  await init();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiClient>(create: (context) => sl<ApiClient>()),
        RepositoryProvider<AuthRepository>(
          create: (context) => sl<AuthRepository>(),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => sl<ProfileRepository>(),
        ),
        RepositoryProvider<HomeRepository>(
          create: (context) => sl<HomeRepository>(),
        ),
        RepositoryProvider<FavoritesRepository>(
          create: (context) => sl<FavoritesRepository>(),
        ),
        RepositoryProvider<HistoryRepository>(
          create: (context) => sl<HistoryRepository>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => sl<AuthCubit>(),
            lazy: false,
          ),
        ],
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp.router(
              routerConfig: goRouter,
              title: 'FaizNation',
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF1a94ff),
                ),
                fontFamily: 'Poppins',
              ),
            );
          },
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'FaizNation',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1a94ff)),
        fontFamily: 'Poppins',
      ),
    );
  }
}
