import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../home/data/models/post_response.dart';
import '../../home/data/post_service.dart';
import '../../favorite/presentation/providers/favorite_provider.dart';
import '../../../routes/route_names.dart';

class CarDetailScreen extends StatefulWidget {
  final int postId;
  const CarDetailScreen({super.key, required this.postId});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  final _postService = PostService();
  final _priceFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
  
  PostResponse? _post;
  bool _loading = true;
  String? _error;
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final post = await _postService.getPostDetail(widget.postId);
      if (!mounted) return;
      setState(() {
        _post = post;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF3D3DC6))),
      );
    }

    if (_error != null || _post == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(_error ?? 'Failed to load details')),
      );
    }

    final car = _post!.vehicle;
    final images = _post!.imageUrls.isNotEmpty ? _post!.imageUrls : [_post!.thumbnail ?? ''];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _post!.title ?? 'Car Detail',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, provider, _) {
              final isFav = provider.isFavorite(_post!.postId ?? 0);
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.black),
                onPressed: () => provider.toggleFavorite(
                  _post!.postId ?? 0,
                  title: _post!.title,
                  price: _post!.price,
                  thumbnail: _post!.thumbnail,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                'Home > Vehicles > ${_post!.title}',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ),

            // Main Image with 360 View button overlay
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(images[_selectedImageIndex]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),

            // Image Thumbnails
            Container(
              height: 80,
              margin: const EdgeInsets.only(top: 20),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedImageIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedImageIndex = index),
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? const Color(0xFF3D3DC6) : Colors.transparent, width: 2),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            ),

            // Vehicle Details Section
            _buildWhiteCard(
              title: 'Vehicle Details',
              child: Text(
                _post!.description ?? 'No description provided.',
                style: TextStyle(color: Colors.grey.shade600, height: 1.6),
              ),
            ),

            // Gallery Section
            _buildSectionHeader('Gallery'),
            const SizedBox(width: 6),
            SizedBox(
              height: 120,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) => Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // Info Card (Tesla Model 1 Long Range, Approved, Price, etc)
            _buildWhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${car?.brand} ${car?.model}\n${car?.version}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _priceFormat.format(_post!.price ?? 0),
                    style: const TextStyle(color: Color(0xFF3D3DC6), fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(_post!.location ?? 'N/A', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      const SizedBox(width: 16),
                      Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text('Posted Jun 10, 2026', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                    ],
                  ),
                  const Divider(height: 32),
                  Row(
                    children: [
                      _buildConditionBadge('Body Insurance'),
                      const SizedBox(width: 12),
                      _buildConditionBadge('Vehicle Inspection'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSpecIcon(Icons.speed, '155 mph', 'Top Speed'),
                      _buildSpecIcon(Icons.timer_outlined, '2.5 sec', '0-60mph'),
                      _buildSpecIcon(Icons.electric_car, '${car?.range ?? 0} km', 'Range'),
                    ],
                  ),
                ],
              ),
            ),

            // Specifications Section
            _buildWhiteCard(
              title: 'Specifications',
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 3,
                children: [
                  _buildSpecRow('Make', car?.brand ?? 'N/A'),
                  _buildSpecRow('Model', car?.model ?? 'N/A'),
                  _buildSpecRow('Color', car?.color ?? 'N/A'),
                  _buildSpecRow('Style', car?.style ?? 'N/A'),
                  _buildSpecRow('Battery', '${car?.batteryCapacity ?? 0}kWh'),
                  _buildSpecRow('Seats', '${car?.numberOfSeat ?? 0}'),
                  _buildSpecRow('Odometer', '${car?.odo ?? 0}km'),
                  _buildSpecRow('Charging', '${car?.chargingTime ?? 0}h'),
                ],
              ),
            ),

            // Location Section
            _buildWhiteCard(
              title: 'Location',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF3D3DC6), size: 18),
                      const SizedBox(width: 8),
                      Text(_post!.location ?? 'Đồng Nai', style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF4F5F7))),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price Cash', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                Text(_priceFormat.format(_post!.price ?? 0), style: const TextStyle(color: Color(0xFF3D3DC6), fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.message_outlined),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text('Buy', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D3DC6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF3D3DC6) : Colors.grey.shade500,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 20,
            color: const Color(0xFF3D3DC6),
          ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildWhiteCard({String? title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildConditionBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF3D3DC6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF3D3DC6), size: 14),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Color(0xFF3D3DC6), fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSpecIcon(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade400, size: 24),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}
