/// Shared form validators for the Voltera app.
///
/// All regex patterns are compiled once as static finals — no per-keystroke
/// recompilation. Each validator returns `null` on success or an error
/// message on failure, matching Flutter's [FormFieldValidator] signature.
abstract final class Validators {
  // ── Pre-compiled regex ──────────────────────────────────────────────────
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _phoneRegex = RegExp(r'^\+?[\d\s\-]{8,15}$');

  /// Validates that [value] is a non-empty, well-formed email address.
  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(text)) return 'Email format is invalid';
    return null;
  }

  /// Validates that [value] is a non-empty password with at least [minLength] characters.
  static String? password(String? value, {int minLength = 6}) {
    final text = value ?? '';
    if (text.isEmpty) return 'Password is required';
    if (text.length < minLength) {
      return 'Password must have at least $minLength characters';
    }
    return null;
  }

  /// Validates that [value] matches [matchValue] (for confirm password fields).
  static String? confirmPassword(String? value, String matchValue) {
    final text = value ?? '';
    if (text.isEmpty) return 'Please confirm your password';
    if (text != matchValue) return 'Passwords do not match';
    return null;
  }

  /// Validates that [value] is a non-empty, well-formed phone number.
  static String? phone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Phone number is required';
    if (!_phoneRegex.hasMatch(text)) return 'Invalid phone number';
    return null;
  }

  /// Validates that [value] is non-empty, using [fieldName] in the error message.
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  Validators._();
}
