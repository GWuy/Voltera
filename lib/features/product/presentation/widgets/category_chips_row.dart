import 'package:flutter/material.dart';

class CategoryChipsRow extends StatelessWidget {
  final String? selectedStyle;
  final Function(String?) onStyleSelected;

  const CategoryChipsRow({
    super.key,
    required this.selectedStyle,
    required this.onStyleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _buildCategoryChip(
            'All',
            Icons.directions_car,
            selectedStyle == null,
          ),
          const SizedBox(width: 12),
          _buildCategoryChip(
            'Sedan',
            Icons.directions_car_filled,
            selectedStyle == 'Sedan',
          ),
          const SizedBox(width: 12),
          _buildCategoryChip('SUV', Icons.garage, selectedStyle == 'SUV'),
          const SizedBox(width: 12),
          _buildCategoryChip('Electric', Icons.electric_car, false),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (label == 'All') {
          onStyleSelected(null);
        } else if (label != 'Electric') {
          onStyleSelected(label);
        }
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
