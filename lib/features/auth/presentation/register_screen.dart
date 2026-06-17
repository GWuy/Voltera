import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:voltera/features/auth/presentation/providers/auth_provider.dart';
import 'package:voltera/features/auth/presentation/widgets/auth_footer_link.dart';
import 'package:voltera/features/auth/presentation/widgets/login_header.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../core/widgets/loading_button.dart';
import '../../../core/router/route_names.dart';

/// Registration screen — thin UI shell.
///
/// All business logic (OTP request, error handling) lives in [AuthProvider].
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _revalidate() => _formKey.currentState?.validate();

  void _submit() {
    final auth = context.read<AuthProvider>();
    auth.clearError();
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    auth.requestRegistrationOtp(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  // Navigate to OTP on success
                  if (auth.status == AuthStatus.success) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final email = _emailController.text.trim();
                      auth.reset();
                      context.go(
                        RouteNames.verifyEmail,
                        extra: {
                          'email': email,
                          'purpose': 'signup',
                          'registrationData': {
                            'username': email,
                            'password': _passwordController.text,
                            'role': 'BUYER',
                          },
                        },
                      );
                    });
                  }

                  final isLoading = auth.status == AuthStatus.loading;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LoginHeader(),
                      const Text('Email', style: AppTextStyles.fieldLabel),
                      const SizedBox(height: 8),
                      AppTextField(
                        controller: _emailController,
                        hintText: 'example@yourdomain.com',
                        prefixIcon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                        onChanged: (_) {
                          auth.clearError();
                          _revalidate();
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password
                      const Text('Password', style: AppTextStyles.fieldLabel),
                      const SizedBox(height: 8),
                      AppTextField(
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
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                        validator: Validators.password,
                        onChanged: (_) {
                          auth.clearError();
                          _revalidate();
                        },
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password
                      const Text('Confirm Password',
                          style: AppTextStyles.fieldLabel),
                      const SizedBox(height: 8),
                      AppTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Re-enter your password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                            size: 22,
                          ),
                          onPressed: () => setState(() =>
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword),
                        ),
                        validator: (v) => Validators.confirmPassword(
                            v, _passwordController.text),
                        onChanged: (_) {
                          auth.clearError();
                          _revalidate();
                        },
                      ),

                      const SizedBox(height: 20),

                      // Server error
                      if (auth.errorMessage != null) ...[
                        ErrorBanner(message: auth.errorMessage!),
                        const SizedBox(height: 28),
                      ],

                      const SizedBox(height: 28),

                      // Sign Up Button — Fixed: was "Sign In"
                      LoadingButton(
                        onPressed: _submit,
                        label: 'Sign Up',
                        isLoading: isLoading,
                      ),

                      const SizedBox(height: 40),

                      // Already have account
                      AuthFooterLink(
                        label: 'Already have an account? ',
                        linkText: 'Login',
                        onTap: () => context.go(RouteNames.login),
                      ),
                      const SizedBox(height: 16),
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
}
