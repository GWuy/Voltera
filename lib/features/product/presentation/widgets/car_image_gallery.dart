import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const _kPrimary = Color(0xFF3D3DC6);

class CarImageGallery extends StatefulWidget {
  final List<String> images;

  const CarImageGallery({super.key, required this.images});

  @override
  State<CarImageGallery> createState() => _CarImageGalleryState();
}

class _CarImageGalleryState extends State<CarImageGallery> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  image: CachedNetworkImageProvider(
                    widget.images[_selectedIndex],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 80,
          margin: const EdgeInsets.only(top: 20),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? _kPrimary : Colors.transparent,
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
