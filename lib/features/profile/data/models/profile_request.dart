class ProfileRequest {
  const ProfileRequest({
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.gender,
    this.address,
  });

  final String? firstname;
  final String? lastname;
  final String? email;
  final String? phone;
  final bool? gender;
  final String? address;

  Map<String, dynamic> toJson() => {
        if (firstname != null) 'firstname': firstname,
        if (lastname != null) 'lastname': lastname,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (gender != null) 'gender': gender,
        if (address != null) 'address': address,
      };
}
