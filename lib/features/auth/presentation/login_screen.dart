import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:voltera/features/auth/presentation/providers/auth_provider.dart';
import 'package:voltera/features/auth/presentation/widgets/auth_footer_link.dart';
import 'package:voltera/features/auth/presentation/widgets/login_header.dart';
import 'package:voltera/features/auth/presentation/widgets/or_divider_row.dart';
import 'package:voltera/features/auth/presentation/widgets/remember_me_row.dart';
import 'package:voltera/features/auth/presentation/widgets/social_login_row.dart';

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

    provider.login(_emailController.text.trim(), _passwordController.text);
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
                        context.go(
                          RouteNames.fillProfile,
                          extra: {
                            'userId': response.userId,
                            'token': response.token,
                            'role': response.role,
                          },
                        );
                      } else {
                        context.go(RouteNames.home);
                      }
                    });
                  }

                  final isLoading = auth.status == AuthStatus.loading;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoginHeader(successMessage: widget.message),

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
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        validator: (v) => Validators.password(v, minLength: 1),
                        onChanged: (_) => auth.clearError(),
                      ),
                      const SizedBox(height: 20),

                      // Remember me + Forgot Password
                      RememberMeRow(
                        value: _rememberMe,
                        onChanged: (value) =>
                            setState(() => _rememberMe = value),
                        onForgotPassword: () {},
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
                      const OrDividerRow(),

                      const SizedBox(height: 24),
                      const SocialLoginRow(),
                      const SizedBox(height: 36),

                      AuthFooterLink(
                        label: "Don't have an account? ",
                        linkText: 'Sign Up',
                        onTap: () => context.go(RouteNames.register),
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
