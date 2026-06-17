import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:voltera/features/auth/presentation/providers/auth_provider.dart';
import 'package:voltera/features/auth/presentation/providers/otp_provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../core/router/route_names.dart';

/// OTP verification screen — thin UI shell.
///
/// Timer countdown and verify-then-register flow managed by [OtpProvider].
class OtpScreen extends StatefulWidget {
  final String email;
  final Map<String, dynamic> registrationData;

  const OtpScreen({
    super.key,
    required this.email,
    required this.registrationData,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _otpLength = 6;

  final List<TextEditingController> _controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_otpLength, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    // Start countdown timer via provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OtpProvider>().startCountdown();
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  // ── OTP helpers ──────────────────────────────────────────────────────────

  String get _currentOtp => _controllers.map((c) => c.text).join();
  bool get _isComplete => _currentOtp.length == _otpLength;

  void _onDigitChanged(int index, String value) {
    context.read<OtpProvider>().clearError();
    if (value.isEmpty) return;
    if (index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else {
      _focusNodes[index].unfocus();
    }
    setState(() {});
  }

  KeyEventResult _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _controllers[index - 1].clear();
        _focusNodes[index - 1].requestFocus();
        setState(() {});
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _verify() {
    if (!_isComplete) {
      return;
    }
    context.read<OtpProvider>().verifyAndRegister(
          email: widget.email,
          otp: _currentOtp,
          registrationData: widget.registrationData,
        );
  }

  void _reset() {
    for (final c in _controllers) {
      c.clear();
    }
    context.read<OtpProvider>().clearError();
    _focusNodes[0].requestFocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => context.pop(),
        ),
        title: const Text('Enter OTP Code', style: AppTextStyles.heading2),
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Consumer2<OtpProvider, AuthProvider>(
                builder: (context, otp, auth, _) {
                  // Handle Success: Login and Navigate
                  if (otp.status == OtpStatus.success) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      otp.resetStatus(); // Custom method to prevent loop
                      auth
                          .login(
                        widget.registrationData['username'] as String,
                        widget.registrationData['password'] as String,
                      )
                          .then((_) {
                        if (auth.status == AuthStatus.success &&
                            auth.loginResponse != null) {
                          final res = auth.loginResponse!;
                          if (!res.updatedProfile) {
                            context.go(RouteNames.fillProfile, extra: {
                              'userId': res.userId,
                              'token': res.token,
                              'role': res.role,
                            });
                          } else {
                            context.go(RouteNames.home);
                          }
                        }
                      });
                    });
                  }

                  final isVerifying = otp.status == OtpStatus.verifying ||
                      auth.status == AuthStatus.loading;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),

                      // Subtitle — Fixed grammar: "A 6-digit code"
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: AppTextStyles.bodySmall
                              .copyWith(height: 1.5),
                          children: [
                            const TextSpan(
                                text: 'A 6-digit code has been sent to\n'),
                            TextSpan(
                              text: widget.email,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      // OTP boxes
                      _buildOtpBoxes(),

                      // Error message
                      if (otp.errorMessage != null || auth.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        ErrorBanner(message: otp.errorMessage ?? auth.errorMessage!),
                      ],

                      const SizedBox(height: 32),

                      // Reset + Continue
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: OutlinedButton(
                                onPressed: isVerifying ? null : _reset,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14)),
                                  backgroundColor: AppColors.fill,
                                ),
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: (isVerifying || !_isComplete)
                                    ? null
                                    : _verify,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor:
                                      AppColors.primaryAlpha50,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14)),
                                  elevation: 0,
                                ),
                                child: isVerifying
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white),
                                      )
                                    : const Text('Continue',
                                        style: AppTextStyles.buttonSmall),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Resend row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive the code? ",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade600),
                          ),
                          GestureDetector(
                            onTap: otp.canResend
                                ? () => otp.resendOtp(widget.email)
                                : null,
                            child: Text(
                              otp.canResend
                                  ? 'Resend'
                                  : 'Resend in ${otp.countdown}s',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: otp.canResend
                                    ? AppColors.primary
                                    : Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        _otpLength,
        (index) => _OtpDigitBox(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          onChanged: (value) => _onDigitChanged(index, value),
          onKeyEvent: (event) => _onKeyEvent(index, event),
        ),
      ),
    );
  }
}

// ── Single OTP digit box ──────────────────────────────────────────────────────

class _OtpDigitBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onChanged;
  final KeyEventResult Function(KeyEvent) onKeyEvent;

  const _OtpDigitBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onKeyEvent,
  });

  @override
  State<_OtpDigitBox> createState() => _OtpDigitBoxState();
}

class _OtpDigitBoxState extends State<_OtpDigitBox> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() =>
      setState(() => _isFocused = widget.focusNode.hasFocus);

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasValue = widget.controller.text.isNotEmpty;

    return KeyboardListener(
      focusNode: FocusNode(skipTraversal: true),
      onKeyEvent: widget.onKeyEvent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 48,
        height: 58,
        decoration: BoxDecoration(
          color: hasValue
              ? const Color(0xFFF0F0FF)
              : AppColors.fill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isFocused
                ? AppColors.primary
                : hasValue
                    ? AppColors.primaryAlpha40
                    : Colors.grey.shade300,
            width: _isFocused ? 2 : 1.5,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: AppColors.primaryAlpha15,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
