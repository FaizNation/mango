import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mango/core/data/new_comic_data.dart';
import 'package:mango/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mango/features/home/presentation/cubit/home_cubit.dart';
import 'package:mango/features/home/presentation/widgets/comic_list_view.dart';
import 'package:mango/features/home/presentation/widgets/new_comic.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState.status != AuthStatus.authenticated) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        final userName = authState.user?.displayName ?? 'Guest';
        return _HomeView(userName: userName);
      },
    );
  }
}

class _HomeView extends StatelessWidget {
  final String userName;
  const _HomeView({required this.userName});

  static const double kMobileBreakpoint = 600.0;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < kMobileBreakpoint;
    final comics = newComic..shuffle();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFE6F2FF),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(state.greeting, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                              const SizedBox(height: 8),
                              Text(
                                userName,
                                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          state.time,
                          style: TextStyle(fontSize: isMobile ? 36 : 50, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  ComicCarousel(comics: comics),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 700),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search manga...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onSubmitted: (query) {
                            if (query.trim().isEmpty) return;
                            context.push('/search/${Uri.encodeComponent(query.trim())}');
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  DefaultTabController(
                    length: 4,
                    child: Column(
                      children: [
                        Container(
                          color: const Color(0xFFFFFFFF),
                          child: TabBar(
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.grey,
                            onTap: (index) => context.read<HomeCubit>().selectTab(HomeTab.values[index]),
                            tabs: const [
                              Tab(icon: Icon(Icons.library_books), text: 'All'),
                              Tab(icon: Icon(Icons.menu_book), text: 'Manga'),
                              Tab(icon: Icon(Icons.auto_stories), text: 'Manhwa'),
                              Tab(icon: Icon(Icons.book), text: 'Manhua'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: ComicListView(
                            comics: state.comics,
                            isLoading: state.status == HomeStatus.loading,
                            onLoadMore: () => context.read<HomeCubit>().loadComics(),
                            error: state.errorMessage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
