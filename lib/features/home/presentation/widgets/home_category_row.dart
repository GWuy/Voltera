import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../providers/home_provider.dart';

const _kPrimary = Color(0xFF3D3DC6);
const _kSurface = Colors.white;
const _kTextMid = Color(0xFF6B7280);

class HomeCategoryRow extends StatelessWidget {
  final HomeProvider homeProvider;

  const HomeCategoryRow({super.key, required this.homeProvider});

  @override
  Widget build(BuildContext context) {
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
}
