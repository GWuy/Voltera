import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/profile_request.dart';
import '../data/profile_service.dart';
import '../../../routes/route_names.dart';

// ── Pre-computed color constants (avoid runtime withValues() in build) ─────────
const _kPrimary            = Color(0xFF3D3DC6);
const _kPrimaryBorder      = Color(0x263D3DC6); // 0.15 alpha
const _kPrimaryShadow      = Color(0x1F3D3DC6); // 0.12 alpha
const _kPrimaryEditShadow  = Color(0x663D3DC6); // 0.40 alpha
const _kPrimaryDisabled    = Color(0x993D3DC6); // 0.60 alpha
const _kPrimaryBtnShadow   = Color(0x663D3DC6); // 0.40 alpha
const _kGenderSelected     = Color(0x143D3DC6); // 0.08 alpha
const _kFill               = Color(0xFFF4F5F7);
const _kText               = Color(0xFF0D0D0D);

class FillProfileScreen extends StatefulWidget {
  final int userId;
  final String token;
  final String role;

  const FillProfileScreen({
    super.key,
    required this.userId,
    required this.token,
    required this.role,
  });

  @override
  State<FillProfileScreen> createState() => _FillProfileScreenState();
}

class _FillProfileScreenState extends State<FillProfileScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool? _gender; // null = not selected, true = Male, false = Female
  bool _isLoading = false;
  bool _isLoadingProfile = true; // loading initial profile data
  bool _emailPrefilled = false;  // true nếu email được lấy từ server
  String? _serverError;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final AnimationController _avatarController;
  late final Animation<double> _avatarScaleAnimation;

  late ProfileService _profileService;

  @override
  void initState() {
    super.initState();
    _profileService = ProfileService(token: widget.token);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _avatarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _avatarScaleAnimation = CurvedAnimation(
      parent: _avatarController,
      curve: Curves.elasticOut,
    );

    _fadeController.forward();
    _avatarController.forward();

    // Fetch existing profile data to pre-fill fields
    _loadProfile();
  }

  /// Gọi GET /api/v1/users/me/profile và pre-fill các field có dữ liệu.
  Future<void> _loadProfile() async {
    try {
      final profile = await _profileService.getMyProfile();
      if (!mounted) return;
      setState(() {
        // Pre-fill email nếu có (thường luôn có từ lúc đăng ký)
        if (profile.email != null && profile.email!.isNotEmpty) {
          _emailController.text = profile.email!;
          _emailPrefilled = true;
        }
        // Pre-fill các field khác nếu không null
        if (profile.firstname != null && profile.firstname!.isNotEmpty) {
          _firstnameController.text = profile.firstname!;
        }
        if (profile.lastname != null && profile.lastname!.isNotEmpty) {
          _lastnameController.text = profile.lastname!;
        }
        if (profile.phone != null && profile.phone!.isNotEmpty) {
          _phoneController.text = profile.phone!;
        }
        if (profile.address != null && profile.address!.isNotEmpty) {
          _addressController.text = profile.address!;
        }
        if (profile.gender != null) {
          _gender = profile.gender;
        }
        _isLoadingProfile = false;
      });
    } catch (_) {
      // Nếu lỗi fetch thì vẫn cho user nhập bình thường
      if (mounted) setState(() => _isLoadingProfile = false);
    }
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _fadeController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  // ── Validators ──────────────────────────────────────────────────────────────

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // ── Static RegExp: compile once, not on every keystroke ─────────────────
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _phoneRegex = RegExp(r'^\+?[\d\s\-]{8,15}$');

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(text)) return 'Email format is invalid';
    return null;
  }

  String? _validatePhone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Phone number is required';
    if (!_phoneRegex.hasMatch(text)) return 'Invalid phone number';
    return null;
  }

  // ── Submit ──────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    setState(() => _serverError = null);
    if (!_formKey.currentState!.validate()) return;
    if (_gender == null) {
      setState(() => _serverError = 'Please select your gender');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _profileService.saveProfile(
        ProfileRequest(
          firstname: _firstnameController.text.trim(),
          lastname: _lastnameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          gender: _gender,
          address: _addressController.text.trim().isEmpty
              ? null
              : _addressController.text.trim(),
        ),
      );

      if (!mounted) return;

      // Navigate to home based on role
      // TODO: Replace with actual home route per role
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully! 🎉'),
          backgroundColor: Color(0xFF059669),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to home (replace with actual route)
      context.go(RouteNames.login,
          extra: {'message': 'Profile completed! Welcome aboard.'});
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() => _serverError = _extractErrorMessage(e));
    } catch (e) {
      if (!mounted) return;
      setState(() => _serverError = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _extractErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final msg = map['message']?.toString() ??
          map['detail']?.toString() ??
          map['error']?.toString();
      if (msg != null && msg.trim().isNotEmpty) return msg;
    }
    if (data is String && data.trim().isNotEmpty) return data;
    if (e.response?.statusCode == 401) {
      return 'Session expired. Please login again.';
    }
    return e.message ?? 'An unknown error occurred';
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoadingProfile
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: _kPrimary),
                  SizedBox(height: 16),
                  Text(
                    'Loading your profile...',
                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                  ),
                ],
              ),
            )
          : FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // ── App bar ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.go(RouteNames.login),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F5F7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: Color(0xFF0D0D0D),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Fill Your Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0D0D0D),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 42), // balance back button
                    ],
                  ),
                ),
              ),

              // ── Avatar ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 8),
                  child: Center(
                    child: ScaleTransition(
                      scale: _avatarScaleAnimation,
                      child: Stack(
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFF0F0F8),
                              border: Border.all(
                                color: _kPrimaryBorder,
                                width: 3,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: _kPrimaryShadow,
                                  blurRadius: 20,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 60,
                              color: Color(0xFF3D3DC6),
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF3D3DC6),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.5,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: _kPrimaryEditShadow,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Subtitle ────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    'Complete your profile to get started',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              // ── Form ─────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First Name & Last Name row
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('First Name'),
                                  const SizedBox(height: 8),
                                  _buildTextField(
                                    controller: _firstnameController,
                                    hintText: 'John',
                                    prefixIcon: Icons.person_outline_rounded,
                                    validator: (v) =>
                                        _validateRequired(v, 'First name'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Last Name'),
                                  const SizedBox(height: 8),
                                  _buildTextField(
                                    controller: _lastnameController,
                                    hintText: 'Doe',
                                    prefixIcon: Icons.person_outline_rounded,
                                    validator: (v) =>
                                        _validateRequired(v, 'Last name'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Email
                        _buildLabel('Email'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _emailController,
                          hintText: 'example@yourdomain.com',
                          prefixIcon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                          readOnly: _emailPrefilled, // không cho sửa nếu đã lấy từ server
                          suffixIcon: _emailPrefilled
                              ? const Icon(Icons.verified_rounded,
                                  color: Color(0xFF059669), size: 20)
                              : null,
                        ),
                        const SizedBox(height: 20),

                        // Phone
                        _buildLabel('Phone Number'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _phoneController,
                          hintText: 'Typing your phone number',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: _validatePhone,
                        ),
                        const SizedBox(height: 20),

                        // Gender
                        _buildLabel('Gender'),
                        const SizedBox(height: 10),
                        _buildGenderSelector(),
                        const SizedBox(height: 20),

                        // Address (optional)
                        _buildLabel('Address (Optional)'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _addressController,
                          hintText: 'Typing your address',
                          prefixIcon: Icons.location_on_outlined,
                          keyboardType: TextInputType.streetAddress,
                        ),
                        const SizedBox(height: 24),

                        // Server error
                        if (_serverError != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline_rounded,
                                    color: Colors.red.shade600, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _serverError!,
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Submit button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3D3DC6),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: _kPrimaryDisabled,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                              shadowColor: _kPrimaryBtnShadow,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Skip for now
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Navigate to home without profile
                              context.go(RouteNames.login);
                            },
                            child: Text(
                              'Skip for now',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Reusable widgets ─────────────────────────────────────────────────────────

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0D0D0D),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    bool readOnly = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      validator: validator,
      onChanged: (_) => setState(() => _serverError = null),
      style: TextStyle(
        fontSize: 15,
        color: readOnly ? const Color(0xFF6B7280) : const Color(0xFF0D0D0D),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon:
            Icon(prefixIcon, color: Colors.grey.shade400, size: 22),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: readOnly ? const Color(0xFFEEEEF8) : const Color(0xFFF4F5F7),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: readOnly
              ? const BorderSide(color: Color(0xFFD1D5DB), width: 1)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFF3D3DC6), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        Expanded(
          child: _GenderOption(
            label: 'Male',
            icon: Icons.male_rounded,
            isSelected: _gender == true,
            onTap: () => setState(() {
              _gender = true;
              _serverError = null;
            }),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _GenderOption(
            label: 'Female',
            icon: Icons.female_rounded,
            isSelected: _gender == false,
            onTap: () => setState(() {
              _gender = false;
              _serverError = null;
            }),
          ),
        ),
      ],
    );
  }
}

// ── Gender Option Widget ──────────────────────────────────────────────────────

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? _kGenderSelected : _kFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3D3DC6)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? const Color(0xFF3D3DC6)
                  : Colors.grey.shade500,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF3D3DC6)
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
