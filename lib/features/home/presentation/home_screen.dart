import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/route_names.dart';
import '../../../features/favorite/presentation/providers/favorite_provider.dart';
import '../../../features/profile/presentation/providers/profile_provider.dart';
import 'providers/home_provider.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_bottom_nav.dart';
import 'widgets/home_category_row.dart';
import 'widgets/home_empty_state.dart';
import 'widgets/home_error_state.dart';
import 'widgets/post_card.dart';
import 'widgets/recommendations_header.dart';

const _kPrimary = Color(0xFF3D3DC6);
const _kBackground = Color(0xFFF7F8FC);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchPosts();
      context.read<ProfileProvider>().loadProfile();
      context.read<FavoriteProvider>().loadFavorites();
    });
    _searchController.addListener(() {
      context.read<HomeProvider>().updateSearch(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, homeProvider, _) {
            return RefreshIndicator(
              onRefresh: homeProvider.refresh,
              color: _kPrimary,
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: HomeAppBar()),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  const SliverToBoxAdapter(child: BannerCarousel()),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: HomeCategoryRow(homeProvider: homeProvider),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                      child: RecommendationsHeader(),
                    ),
                  ),
                  if (homeProvider.loading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(color: _kPrimary),
                      ),
                    )
                  else if (homeProvider.error != null)
                    SliverFillRemaining(
                      child: HomeErrorState(homeProvider: homeProvider),
                    )
                  else if (homeProvider.filteredPosts.isEmpty)
                    const SliverFillRemaining(
                      child: HomeEmptyState(),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = homeProvider.filteredPosts[index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                            child: GestureDetector(
                              onTap: () => context.push(
                                '${RouteNames.carDetail}?postId=${post.postId}',
                              ),
                              child: PostCard(
                                post: post,
                                formatPrice: homeProvider.formatPrice,
                              ),
                            ),
                          );
                        },
                        childCount: homeProvider.filteredPosts.length,
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: _navIndex,
        onIndexChanged: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}
