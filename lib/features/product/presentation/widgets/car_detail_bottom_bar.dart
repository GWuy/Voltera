import 'package:flutter/material.dart';

const _kPrimary = Color(0xFF3D3DC6);

class CarDetailBottomBar extends StatelessWidget {
  final double? price;
  final String Function(double) formatPrice;
  final VoidCallback onBuy;
  final VoidCallback onMessage;

  const CarDetailBottomBar({
    super.key,
    required this.price,
    required this.formatPrice,
    required this.onBuy,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text('Price Cash',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              Text(
                formatPrice(price ?? 0),
                style: const TextStyle(
                    color: _kPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: onMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.message_outlined),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onBuy,
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Buy',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
