import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:voltera/features/auth/presentation/providers/auth_provider.dart';
import 'package:voltera/features/auth/presentation/widgets/social_login_row.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../core/widgets/loading_button.dart';
import '../../../core/router/route_names.dart';

/// Login screen — thin UI shell.
///
/// All business logic (API calls, token storage, navigation decisions)
/// lives in [AuthProvider]. This widget only renders UI and delegates.
class LoginScreen extends StatefulWidget {
  final String? message;

  const LoginScreen({super.key, this.message});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final provider = context.read<AuthProvider>();
    provider.clearError();
    if (!_formKey.currentState!.validate()) return;

    provider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
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
                  // Navigate on success
                  if (auth.status == AuthStatus.success &&
                      auth.loginResponse != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final response = auth.loginResponse!;
                      auth.reset();
                      if (!response.updatedProfile) {
                        context.go(RouteNames.fillProfile, extra: {
                          'userId': response.userId,
                          'token': response.token,
                          'role': response.role,
                        });
                      } else {
                        context.go(RouteNames.home);
                      }
                    });
                  }

                  final isLoading = auth.status == AuthStatus.loading;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Title
                      const Text('Login Your\nAccount',
                          style: AppTextStyles.heading1),
                      const SizedBox(height: 36),

                      // Success banner (from registration)
                      if (widget.message != null) ...[
                        SuccessBanner(message: widget.message!),
                        const SizedBox(height: 20),
                      ],

                      // Email
                      const Text('Email', style: AppTextStyles.fieldLabel),
                      const SizedBox(height: 8),
                      AppTextField(
                        controller: _emailController,
                        hintText: 'example@yourdomain.com',
                        prefixIcon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                        onChanged: (_) => auth.clearError(),
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
                        validator: (v) => Validators.password(v, minLength: 1),
                        onChanged: (_) => auth.clearError(),
                      ),
                      const SizedBox(height: 20),

                      // Remember me + Forgot Password
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(
                                () => _rememberMe = !_rememberMe),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: _rememberMe
                                        ? AppColors.primary
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: _rememberMe
                                          ? AppColors.primary
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
                            child: const Text('Forgot Password',
                                style: AppTextStyles.linkDark),
                          ),
                        ],
                      ),

                      // Error banner
                      if (auth.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        ErrorBanner(message: auth.errorMessage!),
                      ],

                      const SizedBox(height: 28),

                      // Sign In Button
                      LoadingButton(
                        onPressed: _submit,
                        label: 'Sign In',
                        isLoading: isLoading,
                      ),

                      const SizedBox(height: 28),

                      // Or continue with
                      Row(
                        children: [
                          Expanded(
                              child: Divider(color: Colors.grey.shade300)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'or continue with',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Divider(color: Colors.grey.shade300)),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const SocialLoginRow(),
                      const SizedBox(height: 36),

                      // Sign up link — Fixed grammar
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go(RouteNames.register),
                              child: const Text('Sign Up',
                                  style: AppTextStyles.link),
                            ),
                          ],
                        ),
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
