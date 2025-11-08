import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../cubits/home/home_cubit.dart';
import '../../cubits/home/home_state.dart';
import '../../widgets/manga_widget.dart'; // Pastikan widget ini juga responsif!

class MyHomePage extends StatelessWidget {
  final String userName;

  const MyHomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: _MyHomePageView(userName: userName),
    );
  }
}

class _MyHomePageView extends StatelessWidget {
  final String userName;

  const _MyHomePageView({required this.userName});

  // Tentukan breakpoint. 600 pixels sering dipakai sebagai batas
  // antara HP (portrait) dan Tablet (landscape/portrait).
  static const double kMobileBreakpoint = 600.0;

  @override
  Widget build(BuildContext context) {
    // Dapatkan lebar layar saat ini
    final double screenWidth = MediaQuery.of(context).size.width;
    
    // Tentukan apakah ini tampilan mobile
    final bool isMobile = screenWidth < kMobileBreakpoint;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFE6F2FF),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Gunakan Expanded agar Greeting/Username
                      // tidak terdorong oleh Waktu jika namanya panjang
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.greeting,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis, // Hindari overflow
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      // Tambahkan sedikit spasi
                      const SizedBox(width: 16),
                      
                      // Waktu (Time) dengan FONT ADAPTIF
                      Text(
                        state.time,
                        style: TextStyle(
                          // Jika mobile, font 36. Jika tidak (tablet/web), font 50.
                          fontSize: isMobile ? 36 : 50,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Search box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  // Buat lebar search box tidak terlalu lebar di desktop
                  // Kita bisa membungkusnya dengan Center & ConstrainedBox
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700), // Batas lebar maks
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search manga...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onSubmitted: (query) {
                          if (query.trim().isEmpty) return;
                          context.push(
                            '/search/${Uri.encodeComponent(query.trim())}',
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                DefaultTabController(
                  length: 4,
                  child: Expanded(
                    child: Column(
                      children: [
                        Container(
                          color: const Color(0xFFFFFFFF),
                          child: TabBar(
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.grey,
                            onTap: (index) => context
                                .read<HomeCubit>()
                                .selectTab(HomeTab.values[index]),
                            tabs: const [
                              Tab(icon: Icon(Icons.library_books), text: 'All'),
                              Tab(icon: Icon(Icons.menu_book), text: 'Manga'),
                              Tab(
                                icon: Icon(Icons.auto_stories),
                                text: 'Manhwa',
                              ),
                              Tab(icon: Icon(Icons.book), text: 'Manhua'),
                            ],
                          ),
                        ),
                        if (state.error != null)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              state.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              // PENTING:
                              // Pastikan `ComicListView` di bawah ini
                              // SUDAH DIBUAT RESPONSIVE
                              // (lihat Langkah 2 di bawah)
                              ComicListView(
                                comics: state.allManga,
                                isLoading: state.isLoading,
                                onLoadMore: () =>
                                    context.read<HomeCubit>().loadMoreManga(),
                                error: state.error,
                              ),
                              ComicListView(
                                comics: state.manga,
                                isLoading: state.isLoading,
                                onLoadMore: () =>
                                    context.read<HomeCubit>().loadMoreManga(),
                                error: state.error,
                              ),
                              ComicListView(
                                comics: state.manhwa,
                                isLoading: state.isLoading,
                                onLoadMore: () =>
                                    context.read<HomeCubit>().loadMoreManga(),
                                error: state.error,
                              ),
                              ComicListView(
                                comics: state.manhua,
                                isLoading: state.isLoading,
                                onLoadMore: () =>
                                    context.read<HomeCubit>().loadMoreManga(),
                                error: state.error,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}