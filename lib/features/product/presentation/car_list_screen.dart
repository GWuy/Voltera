import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'car_filter_screen.dart';
import '../../home/data/models/post_response.dart';
import '../../favorite/presentation/providers/favorite_provider.dart';
import '../../../core/router/route_names.dart';
import 'providers/product_provider.dart';

class CarListScreen extends StatefulWidget {
  final String? brand;
  const CarListScreen({super.key, this.brand});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  final _searchController = TextEditingController();

  String? _selectedStyle;
  String? _selectedBrand;

  Map<String, dynamic> _currentFilters = {};

  @override
  void initState() {
    super.initState();
    _selectedBrand = widget.brand;
    if (_selectedBrand != null) {
      _currentFilters['brand'] = _selectedBrand;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCars(filters: _currentFilters);
    });
  }

  void _fetchCars({Map<String, dynamic>? filters}) {
    final provider = context.read<ProductProvider>();
    final f = filters ?? _currentFilters;
    provider.filterVehicles(
      keyword:
          f['keyword'] ??
          (_searchController.text.isNotEmpty ? _searchController.text : null),
      address: f['address'],
      brand: f['brand'] ?? _selectedBrand,
      style: f['style'] ?? _selectedStyle,
      version: f['version'],
      color: f['color'],
      origin: f['origin'],
      minOdo: f['minOdo'],
      maxOdo: f['maxOdo'],
      minRange: f['minRange'],
      maxRange: f['maxRange'],
      bodyInsurance: f['bodyInsurance'],
      vehicleInspection: f['vehicleInspection'],
      minPrice: f['minPrice'],
      maxPrice: f['maxPrice'],
      minYearManufacture: f['minYearManufacture'],
      maxYearManufacture: f['maxYearManufacture'],
    );
    if (filters != null) {
      setState(() => _currentFilters = filters);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          onPressed: () => context.pop(),
        ),
        title: Text(
          _selectedBrand ?? 'Available Car',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF3D3DC6)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F5F7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (val) {
                        _currentFilters['keyword'] = val;
                        _fetchCars(filters: _currentFilters);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CarFilterScreen(initialFilters: _currentFilters),
                      ),
                    );
                    if (result != null && result is Map<String, dynamic>) {
                      _fetchCars(filters: result);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF3D3DC6).withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: Color(0xFF3D3DC6),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                _buildCategoryChip(
                  'All',
                  Icons.directions_car,
                  _selectedStyle == null,
                ),
                const SizedBox(width: 12),
                _buildCategoryChip(
                  'Sedan',
                  Icons.directions_car_filled,
                  _selectedStyle == 'Sedan',
                ),
                const SizedBox(width: 12),
                _buildCategoryChip(
                  'SUV',
                  Icons.garage,
                  _selectedStyle == 'SUV',
                ),
                const SizedBox(width: 12),
                _buildCategoryChip('Electric', Icons.electric_car, false),
              ],
            ),
          ),

          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, _) {
                if (provider.listStatus == ProductStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF3D3DC6)),
                  );
                }
                if (provider.listStatus == ProductStatus.error) {
                  return Center(child: Text(provider.errorMessage ?? 'Error'));
                }
                if (provider.cars.isEmpty) {
                  return const Center(child: Text('No cars found'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: provider.cars.length,
                  itemBuilder: (context, index) {
                    final car = provider.cars[index];
                    return GestureDetector(
                      onTap: () => context.push(
                        '${RouteNames.carDetail}?postId=${car.postId}',
                      ),
                      child: _CarCard(car: car),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (label == 'All') {
            _selectedStyle = null;
          } else if (label != 'Electric') {
            _selectedStyle = label;
          }
        });
        _fetchCars();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3D3DC6) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CarCard extends StatelessWidget {
  final PostResponse car;
  const _CarCard({required this.car});

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: car.thumbnail != null
                      ? CachedNetworkImage(
                          imageUrl: car.thumbnail!,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 100,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image_not_supported),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.title ?? 'No Name',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '4.8',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.speed,
                              color: Colors.grey.shade400,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${car.vehicle?.odo ?? 0} km',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          priceFormat.format(car.price ?? 0),
                          style: const TextStyle(
                            color: Color(0xFF3D3DC6),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Consumer<FavoriteProvider>(
              builder: (context, provider, _) {
                final isFav = provider.isFavorite(car.postId ?? 0);
                return GestureDetector(
                  onTap: () => provider.toggleFavorite(
                    car.postId ?? 0,
                    title: car.title,
                    price: car.price,
                    thumbnail: car.thumbnail,
                  ),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey.shade400,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
