enum UserRole {
  buyer('BUYER'),
  seller('SELLER');

  const UserRole(this.value);

  final String value;

  static UserRole fromString(String? value) {
    if (value == null) return UserRole.buyer;
    return UserRole.values.firstWhere(
      (r) => r.value.toUpperCase() == value.toUpperCase(),
      orElse: () => UserRole.buyer,
    );
  }

  String get label => switch (this) {
        UserRole.buyer => 'Buyer',
        UserRole.seller => 'Seller',
      };
}
