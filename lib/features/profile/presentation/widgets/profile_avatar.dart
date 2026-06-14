import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String displayName;

  const ProfileAvatar({
    super.key,
    required this.avatarUrl,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.fillReadOnly,
          image: (avatarUrl != null && avatarUrl!.isNotEmpty)
              ? DecorationImage(
                  image: NetworkImage(avatarUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: (avatarUrl == null || avatarUrl!.isEmpty)
            ? const Icon(Icons.person, size: 80, color: AppColors.primary)
            : null,
      ),
    );
  }
}
