import 'package:flutter/material.dart';

class CarListSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilter;
  final ValueChanged<String> onSubmitted;

  const CarListSearchBar({
    super.key,
    required this.controller,
    required this.onFilter,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                controller: controller,
                onSubmitted: onSubmitted,
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
            onTap: onFilter,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF3D3DC6).withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.tune_rounded, color: Color(0xFF3D3DC6)),
            ),
          ),
        ],
      ),
    );
  }
}
