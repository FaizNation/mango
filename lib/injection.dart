import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mango/core/network/api_client.dart';

// Auth
import 'package:mango/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:mango/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mango/features/auth/domain/repositories/auth_repository.dart';
import 'package:mango/features/auth/domain/usecases/get_user_stream.dart';
import 'package:mango/features/auth/domain/usecases/sign_out.dart';
import 'package:mango/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:mango/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:mango/features/auth/presentation/cubit/auth_cubit.dart';

// Profile
import 'package:mango/features/profile/data/datasources/profile_remote_data_source_impl.dart';
import 'package:mango/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mango/features/profile/domain/repositories/profile_repository.dart';

// Home
import 'package:mango/features/home/data/datasources/home_remote_data_source_impl.dart';
import 'package:mango/features/home/data/repositories/home_repository_impl.dart';
import 'package:mango/features/home/domain/repositories/home_repository.dart';
import 'package:mango/features/home/domain/usecases/get_comics.dart';
import 'package:mango/features/home/domain/usecases/get_comics_by_type.dart';

// Favorites
import 'package:mango/features/favorites/data/datasources/favorites_remote_data_source_impl.dart';
import 'package:mango/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:mango/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:mango/features/favorites/domain/usecases/get_favorites.dart';

// History
import 'package:mango/features/history/data/datasources/history_remote_data_source_impl.dart';
import 'package:mango/features/history/data/repositories/history_repository_impl.dart';
import 'package:mango/features/history/domain/repositories/history_repository.dart';
import 'package:mango/features/history/domain/usecases/get_history.dart';

// Reader
import 'package:mango/features/reader/data/datasources/reader_remote_data_source.dart';
import 'package:mango/features/reader/data/datasources/reader_remote_data_source_impl.dart';
import 'package:mango/features/reader/data/repositories/reader_repository_impl.dart';
import 'package:mango/features/reader/domain/repositories/reader_repository.dart';
import 'package:mango/features/reader/domain/usecases/get_chapters.dart';
import 'package:mango/features/reader/domain/usecases/get_chapter_images.dart';

// Search
import 'package:mango/features/search/data/datasources/search_remote_data_source.dart';
import 'package:mango/features/search/data/datasources/search_remote_data_source_impl.dart';
import 'package:mango/features/search/data/repositories/search_repository_impl.dart';
import 'package:mango/features/search/domain/repositories/search_repository.dart';
import 'package:mango/features/search/domain/usecases/search_comics.dart';

// Comic Detail
import 'package:mango/features/comic_detail/data/datasources/comic_detail_remote_data_source.dart';
import 'package:mango/features/comic_detail/data/repositories/comic_detail_repository_impl.dart';
import 'package:mango/features/comic_detail/domain/repositories/comic_detail_repository.dart';
import 'package:mango/features/comic_detail/domain/usecases/get_comic_detail.dart';

// Router cubits
import 'package:mango/features/reader/presentation/cubit/chapter_route_cubit.dart';
import 'package:mango/features/comic_detail/presentation/cubit/comic_detail_cubit.dart';
import 'package:mango/features/home/presentation/cubit/comic_detail_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Core / external
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<auth.FirebaseAuth>(() => auth.FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Data sources
  sl.registerLazySingleton(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl<auth.FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );
  sl.registerLazySingleton<ProfileRemoteDataSourceImpl>(
    () => ProfileRemoteDataSourceImpl(
      firebaseAuth: sl<auth.FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );
  sl.registerLazySingleton<HomeRemoteDataSourceImpl>(
    () => HomeRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<ReaderRemoteDataSource>(
    () => ReaderRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<FavoritesRemoteDataSourceImpl>(
    () => FavoritesRemoteDataSourceImpl(
      firebaseAuth: sl<auth.FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );
  sl.registerLazySingleton<HistoryRemoteDataSourceImpl>(
    () => HistoryRemoteDataSourceImpl(
      firebaseAuth: sl<auth.FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );
  sl.registerLazySingleton<ComicDetailRemoteDataSource>(
    () => ComicDetailRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSourceImpl>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl<ProfileRemoteDataSourceImpl>(),
    ),
  );

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl<HomeRemoteDataSourceImpl>()),
  );

  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(
      remoteDataSource: sl<FavoritesRemoteDataSourceImpl>(),
    ),
  );

  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(
      remoteDataSource: sl<HistoryRemoteDataSourceImpl>(),
    ),
  );

  sl.registerLazySingleton<ReaderRepository>(
    () => ReaderRepositoryImpl(
      remoteDataSource: sl<ReaderRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(
      remoteDataSource: sl<SearchRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<ComicDetailRepository>(
    () => ComicDetailRepositoryImpl(remoteDataSource: sl<ComicDetailRemoteDataSource>()),
  );

  // Usecases - Auth
  sl.registerLazySingleton(() => GetUserStream(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignOut(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignInWithEmail(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignUpWithEmail(sl<AuthRepository>()));

  // Usecases - Home
  sl.registerLazySingleton(() => GetComics(sl<HomeRepository>()));
  sl.registerLazySingleton(() => GetComicsByType(sl<HomeRepository>()));

  // Usecases - Comic Detail
  sl.registerLazySingleton(() => GetComicDetail(sl<ComicDetailRepository>()));

  // Usecases - Favorites
  sl.registerLazySingleton(() => GetFavorites(sl<FavoritesRepository>()));

  // Usecases - History
  sl.registerLazySingleton(() => GetHistory(sl<HistoryRepository>()));

  // Usecases - Reader
  sl.registerLazySingleton(() => GetChapters(sl<ReaderRepository>()));
  sl.registerLazySingleton(() => GetChapterImages(sl<ReaderRepository>()));

  // Usecases - Search
  sl.registerLazySingleton(() => SearchComics(sl<SearchRepository>()));

  // Cubits / Blocs
  sl.registerFactory(
    () => AuthCubit(getUserStream: sl<GetUserStream>(), signOut: sl<SignOut>()),
  );

  // Chapter route cubit (router)
  sl.registerFactory(() => ChapterRouteCubit(getChapters: sl<GetChapters>()));

  // Comic detail route cubit (router)
  sl.registerFactory(() => ComicDetailRouteCubit(getComicDetail: sl<GetComicDetail>()));

  // Comic detail screen cubit
  sl.registerFactory(() => ComicDetailCubit(sl<ApiClient>()));

  // Additional cubits can be registered here following the same pattern.
}
