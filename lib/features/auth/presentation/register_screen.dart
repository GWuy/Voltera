import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../data/auth_service.dart';
import '../data/register_request.dart';
import '../data/register_response.dart';

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
  final _authService = AuthService();

  String _role = 'BUYER';
  bool _isLoading = false;
  String? _serverError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(text)) {
      return 'Email format is invalid';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Password is required';
    }
    if (text.length < 6) {
      return 'Password must have at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Please confirm your password';
    }
    if (text != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _revalidate() {
    _formKey.currentState?.validate();
  }

  String _extractErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is String && data.trim().isNotEmpty) {
        return data;
      }
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);
        final message =
            map['message']?.toString() ??
            map['error']?.toString() ??
            map['detail']?.toString();
        if (message != null && message.trim().isNotEmpty) {
          return message;
        }
      }
      final statusCode = error.response?.statusCode;
      if (statusCode == 409) {
        return 'This email is already registered';
      }
      final responseMessage = error.message;
      if (responseMessage != null && responseMessage.trim().isNotEmpty) {
        return responseMessage;
      }
    }
    return error.toString();
  }

  Future<void> _submit() async {
    setState(() {
      _serverError = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.register(
        RegisterRequest(
          username: _emailController.text.trim(),
          password: _passwordController.text,
          role: _role,
        ),
      );

      if (!mounted) return;
      _showSuccess(response);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _serverError = _extractErrorMessage(error);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccess(RegisterResponse response) {
    final message = response.status?.trim().isNotEmpty == true
        ? response.status!
        : 'Registration successful';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    _formKey.currentState?.reset();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _role = 'BUYER';
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedRole = (_role == 'BUYER' || _role == 'SELLER')
        ? _role
        : 'BUYER';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Create account',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Register with your email and password.',
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: _validateEmail,
                          onChanged: (_) {
                            setState(() {
                              _serverError = null;
                            });
                            _revalidate();
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          validator: _validatePassword,
                          onChanged: (_) {
                            setState(() {
                              _serverError = null;
                            });
                            _revalidate();
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Confirm password',
                            border: OutlineInputBorder(),
                          ),
                          validator: _validateConfirmPassword,
                          onChanged: (_) {
                            setState(() {
                              _serverError = null;
                            });
                            _revalidate();
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: selectedRole,
                          decoration: const InputDecoration(
                            labelText: 'Role',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'BUYER',
                              child: Text('Buyer'),
                            ),
                            DropdownMenuItem(
                              value: 'SELLER',
                              child: Text('Seller'),
                            ),
                          ],
                          onChanged: _isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    _role = value ?? 'BUYER';
                                  });
                                },
                        ),
                        if (_serverError != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _serverError!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: _isLoading ? null : _submit,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Register'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
