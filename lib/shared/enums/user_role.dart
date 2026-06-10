/// User roles in the Voltera system.
enum UserRole {
  buyer('BUYER'),
  seller('SELLER');

  const UserRole(this.value);

  /// The string value sent to/from the backend API.
  final String value;

  /// Parses a backend string into a [UserRole], defaulting to [buyer].
  static UserRole fromString(String? value) {
    if (value == null) return UserRole.buyer;
    return UserRole.values.firstWhere(
      (r) => r.value.toUpperCase() == value.toUpperCase(),
      orElse: () => UserRole.buyer,
    );
  }

  /// Display-friendly label.
  String get label => switch (this) {
        UserRole.buyer => 'Buyer',
        UserRole.seller => 'Seller',
      };
}
