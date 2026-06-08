class RegisterRequest {
  RegisterRequest({
    required this.username,
    required this.password,
    this.role,
  });

  final String username;
  final String password;
  final String? role;

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      if (role != null && role!.trim().isNotEmpty) 'role': role,
    };
  }
}
