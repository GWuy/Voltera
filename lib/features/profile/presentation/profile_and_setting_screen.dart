import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../data/profile_service.dart';
import '../data/profile_response.dart';
import '../../../routes/route_names.dart';
import '../../../core/utils/token_storage.dart';
import '../../auth/presentation/providers/auth_provider.dart';

class ProfileAndSettingScreen extends StatefulWidget {
  const ProfileAndSettingScreen({super.key});

  @override
  State<ProfileAndSettingScreen> createState() => _ProfileAndSettingScreenState();
}

class _ProfileAndSettingScreenState extends State<ProfileAndSettingScreen> {
  ProfileResponse? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final profile = await ProfileService().getMyProfile();
      if (mounted) {
        setState(() {
          _profile = profile;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleLogout() async {
    try {
      // In a real scenario, you'd call your logout API here.
      // Based on your controller, it expects a username.
      // We can get it from the profile or auth provider.
      final username = _profile?.email ?? '';
      
      // For now, let's clear local storage and go to login
      await TokenStorage.instance.deleteToken();
      if (mounted) context.go(RouteNames.login);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.person_outline, color: Color(0xFF3D3DC6), size: 28),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF3D3DC6)))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // User Header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: const Color(0xFFEEEEF8),
                        backgroundImage: _profile?.avatar != null
                            ? CachedNetworkImageProvider(_profile!.avatar!)
                            : null,
                        child: _profile?.avatar == null
                            ? const Icon(Icons.person, size: 40, color: Color(0xFF3D3DC6))
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _profile?.fullname ?? 'User Name',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _profile?.phone ?? '0000-000-000',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_note_outlined, color: Color(0xFF3D3DC6), size: 30),
                        onPressed: () => context.push(RouteNames.profile),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  _buildSectionTitle('General'),
                  _buildSettingItem(Icons.description_outlined, 'Appointment'),
                  _buildSettingItem(Icons.directions_car_outlined, 'Tes Driver'),
                  _buildSettingItem(Icons.volume_up, 'Vocher'),

                  _buildSectionTitle('Account Setting'),
                  _buildSettingItem(Icons.location_on_outlined, 'Address'),
                  _buildSettingItem(Icons.payment_outlined, 'Payment Methods'),
                  _buildSettingItem(Icons.visibility_outlined, 'Dark Mode', isSwitch: true),
                  _buildSettingItem(Icons.logout_outlined, 'Logout', onTap: _handleLogout),

                  _buildSectionTitle('App Setting'),
                  _buildSettingItem(Icons.description_outlined, 'Language'),
                  _buildSettingItem(Icons.notifications_none_outlined, 'Notification'),
                  _buildSettingItem(Icons.verified_user_outlined, 'Security'),

                  _buildSectionTitle('Support'),
                  _buildSettingItem(Icons.help_outline_outlined, 'Help Center'),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String label, {bool isSwitch = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F5F7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.grey.shade600, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0D0D0D)),
              ),
            ),
            if (isSwitch)
              Switch(
                value: false,
                onChanged: (v) {},
                activeColor: const Color(0xFF3D3DC6),
              )
            else
              Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }
}
