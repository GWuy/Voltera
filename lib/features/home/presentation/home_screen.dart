import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/models/post_response.dart';
import '../../../core/router/route_names.dart';
import '../../../features/profile/presentation/providers/profile_provider.dart';
import '../../../features/favorite/presentation/providers/favorite_provider.dart';
import 'providers/home_provider.dart';

const _kPrimary = Color(0xFF3D3DC6);
const _kBackground = Color(0xFFF7F8FC);
const _kSurface = Colors.white;
const _kTextDark = Color(0xFF0D0D0D);
const _kTextMid = Color(0xFF6B7280);

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
                  SliverToBoxAdapter(child: _buildAppBar()),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),

                  SliverToBoxAdapter(child: _BannerCarousel()),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: _buildCategoryRow(homeProvider),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recommendations',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _kTextDark,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'View all',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _kPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                      child: _buildErrorState(homeProvider),
                    )
                  else if (homeProvider.filteredPosts.isEmpty)
                    const SliverFillRemaining(
                      child: _EmptyState(),
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
                              child: _PostCard(
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
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        final profile = profileProvider.profile;
        final avatarUrl = profile?.avatar;
        final displayName = profile?.fullname ?? profile?.firstname ?? 'Voltera Market';
        final location = profile?.address ?? 'Explore listings';

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _kPrimary, width: 2),
                ),
                child: ClipOval(
                  child: avatarUrl != null
                      ? CachedNetworkImage(
                          imageUrl: avatarUrl,
                          fit: BoxFit.cover,
                          placeholder: (ctx, url) => _avatarPlaceholder(displayName),
                          errorWidget: (ctx, url, err) => _avatarPlaceholder(displayName),
                        )
                      : _avatarPlaceholder(displayName),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _kTextDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 13, color: _kTextMid),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: _kTextMid,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _kSurface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.notifications_none_rounded,
                          color: _kTextDark,
                          size: 24,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _avatarPlaceholder(String name) {
    final initials = name.trim().isNotEmpty
        ? name.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : 'V';
    return Container(
      color: _kPrimary.withValues(alpha: 0.15),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: _kPrimary,
        ),
      ),
    );
  }

  Widget _buildCategoryRow(HomeProvider homeProvider) {
    const categories = [
      (icon: Icons.apps_rounded, label: 'All'),
      (icon: Icons.directions_car_rounded, label: 'Car'),
      (icon: Icons.battery_charging_full_rounded, label: 'Battery'),
    ];

    return Row(
      children: List.generate(categories.length, (i) {
        final selected = homeProvider.selectedCategory == i;
        return Padding(
          padding: EdgeInsets.only(right: i < categories.length - 1 ? 12 : 0),
          child: GestureDetector(
            onTap: () {
              if (i == 1) {
                context.push(RouteNames.carList);
                return;
              }
              homeProvider.selectCategory(i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? _kPrimary : _kSurface,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  if (selected)
                    BoxShadow(
                      color: _kPrimary.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  else
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    categories[i].icon,
                    size: 18,
                    color: selected ? Colors.white : _kTextMid,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    categories[i].label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : _kTextMid,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildErrorState(HomeProvider homeProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 60, color: _kTextMid),
            const SizedBox(height: 12),
            const Text(
              'Could not load posts',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _kTextDark),
            ),
            const SizedBox(height: 4),
            Text(
              homeProvider.error ?? '',
              style: const TextStyle(fontSize: 12, color: _kTextMid),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: homeProvider.refresh,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    const items = [
      (icon: Icons.home_rounded, label: 'Home'),
      (icon: Icons.favorite_border_rounded, label: 'Favourite'),
      (icon: Icons.shopping_bag_outlined, label: 'Orders'),
      (icon: Icons.person_outline_rounded, label: 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _kSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final selected = _navIndex == i;
              return GestureDetector(
                onTap: () {
                  if (i == 1) {
                    context.go(RouteNames.favorites);
                  } else if (i == 3) {
                    context.go(RouteNames.profile);
                  } else {
                    setState(() => _navIndex = i);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? _kPrimary.withValues(alpha: 0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[i].icon,
                        size: 24,
                        color: selected ? _kPrimary : _kTextMid,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                          color: selected ? _kPrimary : _kTextMid,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BannerCarousel extends StatefulWidget {
  const _BannerCarousel();

  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  final _controller = PageController(viewportFraction: 0.88);
  int _page = 0;

  final _banners = const [
    _BannerData(
      title: '10% Discount',
      subtitle: 'Get discount for every order,\nonly valid for today',
      gradient: [Color(0xFF3D3DC6), Color(0xFF6C63FF)],
    ),
    _BannerData(
      title: '5% Cashback',
      subtitle: 'On all battery listings this week,\nshop now & save!',
      gradient: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
    ),
    _BannerData(
      title: 'Free Listing',
      subtitle: 'Post your first car for free,\nlimited time offer',
      gradient: [Color(0xFF059669), Color(0xFF34D399)],
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: _BannerCard(data: _banners[i]),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: _page == i ? 20 : 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: _page == i ? _kPrimary : const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BannerData {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  const _BannerData({required this.title, required this.subtitle, required this.gradient});
}

class _BannerCard extends StatelessWidget {
  final _BannerData data;
  const _BannerCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: data.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: data.gradient.first.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Shop Now',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: data.gradient.first,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Icon(
              Icons.electric_car_rounded,
              size: 76,
              color: Colors.white.withValues(alpha: 0.25),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded, size: 60, color: _kTextMid),
            SizedBox(height: 12),
            Text(
              'No listings found',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _kTextDark),
            ),
            SizedBox(height: 4),
            Text(
              'Try a different category or search',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: _kTextMid),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final PostResponse post;
  final String Function(double?) formatPrice;

  const _PostCard({required this.post, required this.formatPrice});

  @override
  Widget build(BuildContext context) {
    final isBattery = post.isBattery;
    final thumb = post.thumbnail;

    return Container(
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: thumb != null
                    ? CachedNetworkImage(
                        imageUrl: thumb,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        placeholder: (ctx, url) => Container(
                          height: 180,
                          color: const Color(0xFFF3F4F6),
                          child: const Center(
                            child: CircularProgressIndicator(color: _kPrimary, strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (ctx, url, err) => Container(
                          height: 180,
                          color: const Color(0xFFF3F4F6),
                          child: const Icon(Icons.image_not_supported_rounded, color: _kTextMid, size: 40),
                        ),
                      )
                    : Container(
                        height: 180,
                        color: const Color(0xFFF3F4F6),
                        child: Center(
                          child: Icon(
                            isBattery ? Icons.battery_full_rounded : Icons.directions_car_rounded,
                            size: 60,
                            color: _kTextMid,
                          ),
                        ),
                      ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Consumer<FavoriteProvider>(
                  builder: (context, provider, child) {
                    final isFav = provider.isFavorite(post.postId ?? 0);
                    return GestureDetector(
                      onTap: () async {
                        final success = await provider.toggleFavorite(
                          post.postId ?? 0,
                          title: post.title,
                          price: post.price,
                          thumbnail: post.thumbnail,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success
                                  ? (isFav ? 'Removed from favorites' : 'Added to favorites')
                                  : 'Failed to update favorites'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                            )
                          ],
                        ),
                        child: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 18,
                          color: isFav ? Colors.red : _kTextMid,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isBattery ? const Color(0xFF059669) : _kPrimary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isBattery ? Icons.battery_charging_full_rounded : Icons.directions_car_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isBattery ? 'Battery' : 'Car',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title ?? 'No title',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _kTextDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                if (isBattery && post.battery != null)
                  _buildBatteryDetails(post.battery!)
                else if (post.vehicle != null)
                  _buildCarDetails(post.vehicle!),

                const SizedBox(height: 10),

                Row(
                  children: [
                    if (post.location != null) ...[
                      const Icon(Icons.location_on_rounded, size: 14, color: _kTextMid),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          post.location!,
                          style: const TextStyle(fontSize: 12, color: _kTextMid),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ] else
                      const Spacer(),
                    Flexible(
                      child: Text(
                        formatPrice(post.price),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _kPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryDetails(dynamic battery) {
    return Wrap(
      spacing: 12,
      children: [
        _Detail(icon: Icons.bolt_rounded, label: '${battery.voltage?.toStringAsFixed(0) ?? '--'} V'),
        _Detail(icon: Icons.loop_rounded, label: '${battery.cycleCount ?? '--'} cycles'),
        _Detail(icon: Icons.speed_rounded, label: '${battery.mileageCovered ?? '--'} km'),
      ],
    );
  }

  Widget _buildCarDetails(dynamic vehicle) {
    return Wrap(
      spacing: 12,
      children: [
        _Detail(icon: Icons.branding_watermark_rounded, label: vehicle.brand ?? '--'),
        _Detail(icon: Icons.calendar_today_rounded, label: '${vehicle.year ?? '--'}'),
        if (vehicle.vehicleType != null)
          _Detail(icon: Icons.category_rounded, label: vehicle.vehicleType!),
      ],
    );
  }
}

class _Detail extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Detail({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: _kTextMid),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: _kTextMid),
          ),
        ),
      ],
    );
  }
}
