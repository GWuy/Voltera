import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/auth_service.dart';
import '../data/login_request.dart';
import '../data/login_response.dart';
import '../../../routes/route_names.dart';

class LoginScreen extends StatefulWidget {
  /// Optional success message passed from registration flow.
  final String? message;

  const LoginScreen({super.key, this.message});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  // ── Use ValueNotifier so only the error banner rebuilds, not the whole screen
  final _serverErrorNotifier = ValueNotifier<String?>( null);

  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  // ── Static RegExp: compiled once per class, not on every keystroke ─────────
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _serverErrorNotifier.dispose();
    super.dispose();
  }

  // ── Validators ─────────────────────────────────────────────────────────────

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(text)) return 'Email format is invalid';
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Password is required';
    return null;
  }

  // ── Submit ─────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    _serverErrorNotifier.value = null;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final LoginResponse response = await _authService.login(
        LoginRequest(
          username: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );

      if (!mounted) return;

      // ─── Check if profile has been filled ──────────────────────────────
      if (!response.updatedProfile) {
        context.go(
          RouteNames.fillProfile,
          extra: {
            'userId': response.userId,
            'token': response.token,
            'role': response.role,
          },
        );
        return;
      }

      // ─── Profile already filled → go to home ───────────────────────────
      // TODO: Replace with RouteNames.home based on role
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Welcome back! Role: ${response.role} (userId: ${response.userId})'),
          backgroundColor: const Color(0xFF059669),
        ),
      );
    } on DioException catch (e) {
      if (!mounted) return;
      _serverErrorNotifier.value = _extractErrorMessage(e);
    } catch (e) {
      if (!mounted) return;
      _serverErrorNotifier.value = e.toString();
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
      return 'Incorrect email or password.';
    }
    return e.message ?? 'An unknown error occurred';
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Title
                const Text(
                  'Login Your\nAccount',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0D0D0D),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 36),

                // Success banner (from registration)
                if (widget.message != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF6EE7B7)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline,
                            color: Color(0xFF059669), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.message!,
                            style: const TextStyle(
                              color: Color(0xFF065F46),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Email
                _buildLabel('Email'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'xampl@yourdomain.com',
                  prefixIcon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  // ✅ Only clear error, no full tree rebuild
                  onChanged: (_) => _serverErrorNotifier.value = null,
                ),
                const SizedBox(height: 20),

                // Password
                _buildLabel('Password'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Typing your password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 22,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: _validatePassword,
                  // ✅ Only clear error, no full tree rebuild
                  onChanged: (_) => _serverErrorNotifier.value = null,
                ),
                const SizedBox(height: 20),

                // Remember me + Forgot Password
                Row(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          setState(() => _rememberMe = !_rememberMe),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: _rememberMe
                                  ? const Color(0xFF3D3DC6)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: _rememberMe
                                    ? const Color(0xFF3D3DC6)
                                    : Colors.grey.shade400,
                                width: 1.5,
                              ),
                            ),
                            child: _rememberMe
                                ? const Icon(Icons.check,
                                    size: 15, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // TODO: navigate to forgot password screen
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D0D0D),
                        ),
                      ),
                    ),
                  ],
                ),

                // ✅ ValueListenableBuilder: only THIS widget rebuilds on error
                ValueListenableBuilder<String?>(
                  valueListenable: _serverErrorNotifier,
                  builder: (context, error, _) {
                    if (error == null) return const SizedBox.shrink();
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red.shade600, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  error,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 28),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D3DC6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 28),

                // Or continue with
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or continue with',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),

                const SizedBox(height: 24),

                // ✅ const constructors: Flutter skips diffing/rebuilding these
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SocialIconButton(icon: _GoogleIcon()),
                    SizedBox(width: 16),
                    _SocialIconButton(icon: _FacebookIcon()),
                    SizedBox(width: 16),
                    _SocialIconButton(icon: _GitHubIcon()),
                  ],
                ),

                const SizedBox(height: 36),

                // Sign up link
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Already haven't an account? ",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(RouteNames.register),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3D3DC6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Reusable widgets ───────────────────────────────────────────────────────

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
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
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 15, color: Color(0xFF0D0D0D)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: Colors.grey.shade500, size: 22),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF4F5F7),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF3D3DC6), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  // _buildSocialButton removed — replaced by const _SocialIconButton widget below
}

// ── Static const social button — never rebuilt by Flutter diffing ─────────────
class _SocialIconButton extends StatelessWidget {
  final Widget icon;
  const _SocialIconButton({required this.icon});

  // ✅ Static decoration: created once, not per-build
  static const _kShadowColor = Color(0x0A000000); // black @ 0.04 opacity
  static const _decoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(14)),
    boxShadow: [
      BoxShadow(
        color: _kShadowColor,
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: _decoration.copyWith(
        border: Border.all(
          color: const Color(0xFFE5E7EB), // grey.shade200 as const
          width: 1.5,
        ),
      ),
      child: Center(child: icon),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Social icons
// ─────────────────────────────────────────────────────────────────────────────

// ✅ const constructor: Flutter element is never recreated
class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    // ✅ Static instance reused across rebuilds — no new allocation per frame
    return const CustomPaint(size: Size(26, 26), painter: _googlePainter);
  }
}

// Singleton painter — declared at file scope so _GoogleIcon can reference it as const
const _googlePainter = _GooglePainter();

class _GooglePainter extends CustomPainter {
  // ✅ const constructor — required for compile-time constant instantiation
  const _GooglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Simplified "G" logo with 4 colors
    final colors = [
      const Color(0xFF4285F4),
      const Color(0xFFEA4335),
      const Color(0xFFFBBC05),
      const Color(0xFF34A853),
    ];

    final center = Offset(w / 2, h / 2);
    final radius = w / 2;
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = w * 0.18;

    // Draw 4 arcs
    final angles = [
      [-0.1, 1.3],
      [1.2, 1.3],
      [2.5, 1.3],
      [3.8, 1.4],
    ];
    for (int i = 0; i < 4; i++) {
      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.7),
        angles[i][0],
        angles[i][1],
        false,
        paint,
      );
    }

    // White center + right tab
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.4, whitePaint);
    canvas.drawRect(
      Rect.fromLTWH(w * 0.5, h * 0.35, w * 0.5, h * 0.30),
      whitePaint,
    );

    // Blue right tab line
    paint
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.18;
    canvas.drawLine(
      Offset(w * 0.5, h * 0.5),
      Offset(w * 0.88, h * 0.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ✅ const constructor + const body: entire subtree is compile-time constant
class _FacebookIcon extends StatelessWidget {
  const _FacebookIcon();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 28,
      height: 28,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xFF1877F2),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            'f',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _GitHubIcon extends StatelessWidget {
  const _GitHubIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(28, 28), painter: _GitHubIconPainter());
  }
}

// ✅ const constructor so painter instance is compile-time constant
class _GitHubIconPainter extends CustomPainter {
  const _GitHubIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1B1F23)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    canvas.drawCircle(Offset(w / 2, h / 2), w / 2, paint);

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final cx = w / 2;
    final cy = h / 2;
    final r = w * 0.28;

    canvas.drawCircle(Offset(cx, cy - r * 0.15), r, whitePaint);

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, cy + r * 0.85),
        width: r * 1.5,
        height: r * 1.2,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(bodyRect, whitePaint);

    final leftEar = Path()
      ..moveTo(cx - r * 0.7, cy - r * 0.9)
      ..lineTo(cx - r * 0.35, cy - r * 1.2)
      ..lineTo(cx - r * 0.05, cy - r * 0.85)
      ..close();
    canvas.drawPath(leftEar, whitePaint);

    final rightEar = Path()
      ..moveTo(cx + r * 0.7, cy - r * 0.9)
      ..lineTo(cx + r * 0.35, cy - r * 1.2)
      ..lineTo(cx + r * 0.05, cy - r * 0.85)
      ..close();
    canvas.drawPath(rightEar, whitePaint);

    final facePaint = Paint()
      ..color = const Color(0xFF1B1F23)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - r * 0.3, cy - r * 0.1), r * 0.12, facePaint);
    canvas.drawCircle(Offset(cx + r * 0.3, cy - r * 0.1), r * 0.12, facePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
