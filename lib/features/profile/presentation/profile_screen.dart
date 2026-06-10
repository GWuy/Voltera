import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/profile_request.dart';
import '../data/profile_service.dart';
import '../../../routes/route_names.dart';
import '../../../core/utils/token_storage.dart';

// ── Constants for UI styling ──────────────────────────────────────────────────
const _kPrimary = Color(0xFF3D3DC6);
const _kFill = Color(0xFFF4F5F7);
const _kText = Color(0xFF0D0D0D);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  bool? _gender; // true = Male, false = Female
  String? _avatarUrl;
  
  bool _fetchingData = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final token = await TokenStorage.instance.getToken();
      if (token == null) {
        if (mounted) context.go(RouteNames.login);
        return;
      }

      final profileService = ProfileService();
      final profile = await profileService.getMyProfile();

      if (mounted) {
        setState(() {
          _fullnameController.text = profile.fullname ?? '';
          _emailController.text = profile.email ?? '';
          _phoneController.text = profile.phone ?? '';
          _addressController.text = profile.address ?? '';
          _gender = profile.gender;
          _avatarUrl = profile.avatar;
          _fetchingData = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _fetchingData = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load profile')),
        );
      }
    }
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final profileService = ProfileService();
      
      // Tách fullname thành firstname và lastname
      final nameParts = _fullnameController.text.trim().split(' ');
      String firstname = nameParts.isNotEmpty ? nameParts[0] : '';
      String lastname = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final request = ProfileRequest(
        firstname: firstname,
        lastname: lastname,
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        gender: _gender,
        address: _addressController.text.trim(),
        avatarUrl: _avatarUrl,
      );

      await profileService.saveProfile(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_fetchingData) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: _kPrimary)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _kText),
          onPressed: () => context.go(RouteNames.home),
        ),
        title: const Text(
          'Fill Your Profile',
          style: TextStyle(
            color: _kText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // ── Avatar Section ──────────────────────────────────────────
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFEEEEF8),
                    image: (_avatarUrl != null && _avatarUrl!.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(_avatarUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: (_avatarUrl == null || _avatarUrl!.isEmpty)
                      ? const Icon(
                          Icons.person,
                          size: 80,
                          color: _kPrimary,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 32),

              // ── Full Name ──────────────────────────────────────────────
              _buildLabel('Full Name'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _fullnameController,
                hintText: 'Typing your name',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 20),

              // ── Email ──────────────────────────────────────────────────
              _buildLabel('Email'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hintText: 'example@yourdomain.com',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),

              // ── Phone ──────────────────────────────────────────────────
              _buildLabel('No Phone'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _phoneController,
                hintText: 'Typing your phone number',
                prefixIcon: Icons.phone_outlined,
              ),
              const SizedBox(height: 20),

              // ── Gender (Dropdown) ──────────────────────────────────────
              _buildLabel('Gender'),
              const SizedBox(height: 8),
              _buildGenderDropdown(),
              const SizedBox(height: 20),

              // ── Address ────────────────────────────────────────────────
              _buildLabel('Address'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _addressController,
                hintText: 'Typing your address',
                prefixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 40),

              // ── Submit Button ──────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleUpdate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _kText,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 15, color: _kText),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: Colors.grey, size: 22),
        filled: true,
        fillColor: _kFill,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<bool>(
      value: _gender,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person_outline, color: Colors.grey, size: 22),
        filled: true,
        fillColor: _kFill,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      borderRadius: BorderRadius.circular(12),
      dropdownColor: Colors.white,
      hint: const Text('Select Gender', style: TextStyle(color: Colors.grey, fontSize: 14)),
      items: const [
        DropdownMenuItem(value: true, child: Text('Male')),
        DropdownMenuItem(value: false, child: Text('Female')),
      ],
      onChanged: (val) {
        setState(() => _gender = val);
      },
    );
  }
}
