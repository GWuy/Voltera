class LoginResponse {
  LoginResponse({
    required this.userId,
    required this.token,
    required this.role,
  });

  final int userId;
  final String token;
  final String role;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: (json['userId'] as num).toInt(),
      token: json['token'] as String,
      role: json['role'] as String,
    );
  }
}
