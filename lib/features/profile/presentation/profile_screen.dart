import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../data/models/profile_request.dart';
import '../presentation/providers/profile_provider.dart';
import '../../../core/router/route_names.dart';
import '../../../core/utils/token_storage.dart';
import '../../../core/theme/app_colors.dart';

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

  bool? _gender;
  String? _avatarUrl;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  Future<void> _loadProfileData() async {
    final token = await TokenStorage.instance.getToken();
    if (token == null) {
      if (mounted) context.go(RouteNames.login);
      return;
    }

    if (!mounted) return;
    final provider = context.read<ProfileProvider>();
    await provider.loadProfile();

    if (!mounted) return;
    final profile = provider.profile;
    if (profile != null) {
      setState(() {
        _fullnameController.text = profile.fullname ?? '';
        _emailController.text = profile.email ?? '';
        _phoneController.text = profile.phone ?? '';
        _addressController.text = profile.address ?? '';
        _gender = profile.gender;
        _avatarUrl = profile.avatar;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ProfileProvider>();
    bool success = true;

    if (_pickedImage != null) {
      final uploadedUrl = await provider.uploadAvatar(_pickedImage!);
      if (!mounted) return;
      if (uploadedUrl == null) {
        final error = provider.errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error ?? 'Failed to upload avatar')),
        );
        return;
      }
      setState(() {
        _avatarUrl = uploadedUrl;
        _pickedImage = null;
      });
    }

    final nameParts = _fullnameController.text.trim().split(' ');
    final firstname = nameParts.isNotEmpty ? nameParts[0] : '';
    final lastname = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final request = ProfileRequest(
      firstname: firstname,
      lastname: lastname,
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      gender: _gender,
      address: _addressController.text.trim(),
    );

    success = await provider.saveProfile(request);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } else {
      final error = provider.errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Failed to update profile')),
      );
    }
  }

  Future<void> _handleLogout() async {
    final email = _emailController.text.trim();
    final success = await context.read<ProfileProvider>().logout(email);
    if (!mounted) return;

    if (success) {
      await TokenStorage.instance.deleteToken();
      context.go(RouteNames.login);
    } else {
      final error = context.read<ProfileProvider>().errorMessage;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error ?? 'Logout failed')));
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
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final isLoading = provider.status == ProfileStatus.loading;

        if (provider.status == ProfileStatus.loading &&
            provider.profile == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
              onPressed: () => context.go(RouteNames.home),
            ),
            title: const Text(
              'Fill Your Profile',
              style: TextStyle(
                color: AppColors.textDark,
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
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.fillReadOnly,
                            image: _pickedImage != null
                                ? DecorationImage(
                                    image: FileImage(_pickedImage!),
                                    fit: BoxFit.cover,
                                  )
                                : (_avatarUrl != null && _avatarUrl!.isNotEmpty)
                                ? DecorationImage(
                                    image: NetworkImage(_avatarUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child:
                              (_pickedImage == null &&
                                  (_avatarUrl == null || _avatarUrl!.isEmpty))
                              ? const Icon(
                                  Icons.person,
                                  size: 80,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildLabel('Full Name'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _fullnameController,
                    hintText: 'Typing your name',
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Email'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _emailController,
                    hintText: 'example@yourdomain.com',
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('No Phone'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _phoneController,
                    hintText: 'Typing your phone number',
                    prefixIcon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Gender'),
                  const SizedBox(height: 8),
                  _buildGenderDropdown(),
                  const SizedBox(height: 20),

                  _buildLabel('Address'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _addressController,
                    hintText: 'Typing your address',
                    prefixIcon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: isLoading ? null : _handleLogout,
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handleUpdate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
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
      },
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
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
      style: const TextStyle(fontSize: 15, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: Colors.grey, size: 22),
        filled: true,
        fillColor: AppColors.fill,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
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
        prefixIcon: const Icon(
          Icons.person_outline,
          color: Colors.grey,
          size: 22,
        ),
        filled: true,
        fillColor: AppColors.fill,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      borderRadius: BorderRadius.circular(12),
      dropdownColor: Colors.white,
      hint: const Text(
        'Select Gender',
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ),
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
