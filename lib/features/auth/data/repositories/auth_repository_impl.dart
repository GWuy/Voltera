import '../../domain/repositories/auth_repository.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';
import '../models/register_response.dart';
import '../services/auth_api_service.dart';
import '../services/otp_api_service.dart';

/// Concrete implementation of [AuthRepository].
///
/// Delegates to [AuthApiService] and [OtpApiService] for network calls.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    AuthApiService? authApiService,
    OtpApiService? otpApiService,
  })  : _authApi = authApiService ?? AuthApiService(),
        _otpApi = otpApiService ?? OtpApiService();

  final AuthApiService _authApi;
  final OtpApiService _otpApi;

  @override
  Future<LoginResponse> login(LoginRequest request) =>
      _authApi.login(request);

  @override
  Future<RegisterResponse> register(RegisterRequest request) =>
      _authApi.register(request);

  @override
  Future<void> requestOtp(String email) => _otpApi.requestOtp(email);

  @override
  Future<void> verifyRegisterOtp(String email, String otp) =>
      _otpApi.verifyRegisterOtp(email, otp);

  @override
  Future<void> resendOtp(String email) => _otpApi.resendOtp(email);
}