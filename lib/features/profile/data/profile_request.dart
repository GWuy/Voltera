class ProfileRequest {
  ProfileRequest({
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.gender,
    this.address,
    this.avatarUrl,
  });

  final String? firstname;
  final String? lastname;
  final String? email;
  final String? phone;
  final bool? gender;
  final String? address;
  final String? avatarUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (firstname != null) map['firstname'] = firstname;
    if (lastname != null) map['lastname'] = lastname;
    if (email != null) map['email'] = email;
    if (phone != null) map['phone'] = phone;
    if (gender != null) map['gender'] = gender;
    if (address != null) map['address'] = address;
    if (avatarUrl != null) map['avatarUrl'] = avatarUrl;
    return map;
  }
}
