class LoginResponse {
  LoginResponse({
    required this.userId,
    required this.token,
    required this.role,
    required this.updatedProfile,
  });

  final int userId;
  final String token;
  final String role;
  final bool updatedProfile;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: (json['userId'] as num).toInt(),
      token: json['token'] as String,
      role: json['role'] as String,
      updatedProfile: (json['updatedProfile'] as bool?) ?? false,
    );
  }
}
