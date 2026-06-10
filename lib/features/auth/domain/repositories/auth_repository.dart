import 'package:voltera/features/auth/data/models/login_request.dart';
import 'package:voltera/features/auth/data/models/login_response.dart';
import 'package:voltera/features/auth/data/models/register_request.dart';
import 'package:voltera/features/auth/data/models/register_response.dart';



/// Abstract interface for authentication operations.
///
/// This abstraction allows the presentation layer to depend on a contract
/// rather than a concrete implementation, enabling easy testing with mocks.
abstract class AuthRepository {
  /// Authenticates a user and returns a [LoginResponse] with token.
  Future<LoginResponse> login(LoginRequest request);

  /// Creates a new user account.
  Future<RegisterResponse> register(RegisterRequest request);

  /// Requests an OTP code to be sent to [email].
  Future<void> requestOtp(String email);

  /// Verifies the OTP code for registration.
  Future<void> verifyRegisterOtp(String email, String otp);

  /// Resends the OTP code to [email].
  Future<void> resendOtp(String email);
}
