import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'providers/favorite_provider.dart';
import '../../../routes/route_names.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<FavoriteProvider>().loadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go(RouteNames.home),
        ),
        title: const Text(
          'Favorites',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.favorites.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF3D3DC6)));
          }

          if (provider.favorites.isEmpty) {
            return const Center(
              child: Text(
                'No favorite cars yet',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${provider.favorites.length} Items',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: provider.favorites.length,
                  itemBuilder: (context, index) {
                    final car = provider.favorites[index];
                    return _buildCarCard(car, provider);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCarCard(car, FavoriteProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Car Image and Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Expanded(
                    flex: 4,
                    child: car.thumbnailUrl != null
                        ? Image.network(
                            car.thumbnailUrl!,
                            height: 100,
                            fit: BoxFit.contain,
                          )
                        : const Icon(Icons.directions_car, size: 80, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  // Name and Rating
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          car.postTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 36),
                        //price
                        Text(
                          _currencyFormat.format(car.price),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3D3DC6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
          // Heart Icon
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () async {
                final success = await provider.toggleFavorite(car.postId);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'Removed from favorites' : 'Failed to remove'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: const Icon(
                Icons.favorite,
                color: Color(0xFF3D3DC6),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
