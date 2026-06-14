import '../../domain/repositories/profile_repository.dart';
import '../models/profile_request.dart';
import '../models/profile_response.dart';
import '../services/profile_api_service.dart';

/// Concrete implementation of [ProfileRepository].
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({ProfileApiService? apiService})
      : _apiService = apiService ?? ProfileApiService();

  final ProfileApiService _apiService;

  @override
  Future<ProfileResponse> getMyProfile() => _apiService.getMyProfile();

  @override
  Future<ProfileResponse> saveProfile(ProfileRequest request) =>
      _apiService.saveProfile(request);

  @override
  Future<void> logout(String username) => _apiService.logout(username);
}
