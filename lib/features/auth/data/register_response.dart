class RegisterResponse {
  RegisterResponse({
    this.id,
    this.email,
    this.username,
    this.role,
    this.status,
  });

  final int? id;
  final String? email;
  final String? username;
  final String? role;
  final String? status;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      email: json['email']?.toString(),
      username: json['username']?.toString(),
      role: json['role']?.toString(),
      status: json['status']?.toString(),
    );
  }
}
