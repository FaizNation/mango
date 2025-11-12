import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Hapus import go_router karena kita tidak push ke /search lagi
// import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../cubits/home/home_cubit.dart';
import '../../cubits/home/home_state.dart';
import '../../widgets/manga_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _userName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'Guest';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return BlocProvider(
      create: (_) => HomeCubit(),
      // Kita butuh BlocProvider di atas _MyHomePageView
      // agar kita bisa menggunakan BlocBuilder
      child: _MyHomePageView(userName: _userName),
    );
  }
}

// --- KONVERSI KE STATEFUL WIDGET ---
// Kita ubah menjadi StatefulWidget agar bisa menyimpan TextEditingController
// untuk mengontrol TextField pencarian (terutama untuk tombol 'clear')
class _MyHomePageView extends StatefulWidget {
  final String userName;
  const _MyHomePageView({required this.userName});

  static const double kMobileBreakpoint = 600.0;

  @override
  State<_MyHomePageView> createState() => _MyHomePageViewState();
}

class _MyHomePageViewState extends State<_MyHomePageView> {
  // Controller untuk TextField
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan lebar layar saat ini
    final double screenWidth = MediaQuery.of(context).size.width;

    // Tentukan apakah ini tampilan mobile
    final bool isMobile = screenWidth < _MyHomePageView.kMobileBreakpoint;

    return BlocBuilder<HomeCubit, HomeState>(
      // Kita pakai buildWhen agar UI tidak rebuild saat greeting/time update
      // Ini opsional tapi bagus untuk performa
      buildWhen: (prev, current) =>
          prev.isInSearchMode != current.isInSearchMode ||
          prev.isLoading != current.isLoading ||
          prev.isSearching != current.isSearching ||
          prev.searchResults != current.searchResults ||
          prev.error != current.error,
      builder: (context, state) {
        // Kita juga butuh BlocListener untuk mengupdate controller
        // jika kueri dibersihkan dari Cubit
        return BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state.searchQuery.isEmpty && _searchController.text.isNotEmpty) {
              _searchController.clear();
            }
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFE6F2FF),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- BAGIAN HEADER (MENGGUNAKAN BLOCBUILDER KECIL) ---
                  // Kita pisahkan agar greeting & time tetap update
                  // tanpa memicu rebuild seluruh halaman
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Greeting
                              BlocBuilder<HomeCubit, HomeState>(
                                buildWhen: (p, c) => p.greeting != c.greeting,
                                builder: (context, state) {
                                  return Text(
                                    state.greeting,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              // Username
                              Text(
                                widget.userName,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Time
                        BlocBuilder<HomeCubit, HomeState>(
                          buildWhen: (p, c) => p.time != c.time,
                          builder: (context, state) {
                            return Text(
                              state.time,
                              style: TextStyle(
                                fontSize: isMobile ? 36 : 50,
                                fontWeight: FontWeight.w800,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // --- SEARCH BOX (DIMODIFIKASI) ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 700),
                        child: TextField(
                          // Gunakan controller
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search manga...',
                            prefixIcon: const Icon(Icons.search),
                            // Tambah tombol clear (X)
                            suffixIcon: state.isInSearchMode
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      // Panggil clearSearch di cubit
                                      context.read<HomeCubit>().clearSearch();
                                      // Controller juga dibersihkan
                                      _searchController.clear();
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          // GANTI onSubmitted MENJADI onChanged
                          onChanged: (query) {
                            // Panggil method baru di cubit
                            context.read<HomeCubit>().onSearchQueryChanged(query);
                          },
                          // HAPUS onSubmitted
                          // onSubmitted: (query) { ... }
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- KONTEN UTAMA (TAB ATAU HASIL PENCARIAN) ---
                  if (state.error != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          state.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),

                  // Tampilkan hasil pencarian ATAU tab manga
                  Expanded(
                    child: state.isInSearchMode
                        // --- TAMPILKAN HASIL PENCARIAN ---
                        ? ComicListView(
                            comics: state.searchResults,
                            isLoading: state.isSearching,
                            // Ganti ke loadMoreSearch
                            onLoadMore: () =>
                                context.read<HomeCubit>().loadMoreSearch(),
                            error: state.error,
                            // Tambahkan pesan jika kosong
                            emptyText: 'No results found',
                          )
                        // --- TAMPILKAN TAB MANGA (SEPERTI SEMULA) ---
                        : DefaultTabController(
                            length: 4,
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
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      ComicListView(
                                        comics: state.allManga,
                                        isLoading: state.isLoading,
                                        onLoadMore: () => context
                                            .read<HomeCubit>()
                                            .loadMoreManga(),
                                        error: state.error,
                                      ),
                                      ComicListView(
                                        comics: state.manga,
                                        isLoading: state.isLoading,
                                        onLoadMore: () => context
                                            .read<HomeCubit>()
                                            .loadMoreManga(),
                                        error: state.error,
                                      ),
                                      ComicListView(
                                        comics: state.manhwa,
                                        isLoading: state.isLoading,
                                        onLoadMore: () => context
                                            .read<HomeCubit>()
                                            .loadMoreManga(),
                                        error: state.error,
                                      ),
                                      ComicListView(
                                        comics: state.manhua,
                                        isLoading: state.isLoading,
                                        onLoadMore: () => context
                                            .read<HomeCubit>()
                                            .loadMoreManga(),
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
          ),
        );
      },
    );
  }
}