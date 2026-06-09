class ProfileResponse {
  ProfileResponse({
    this.id,
    this.firstname,
    this.lastname,
    this.fullname,
    this.email,
    this.phone,
    this.gender,
    this.address,
    this.createAt,
    this.updateAt,
    this.avatar,
  });

  final int? id;
  final String? firstname;
  final String? lastname;
  final String? fullname;
  final String? email;
  final String? phone;
  final bool? gender;
  final String? address;
  final DateTime? createAt;
  final DateTime? updateAt;
  final String? avatar;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      id: json['id'] as int?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      fullname: json['fullname'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      gender: json['gender'] as bool?,
      address: json['address'] as String?,
      createAt: json['createAt'] != null
          ? DateTime.tryParse(json['createAt'].toString())
          : null,
      updateAt: json['updateAt'] != null
          ? DateTime.tryParse(json['updateAt'].toString())
          : null,
      avatar: json['avatar'] as String?,
    );
  }
}
