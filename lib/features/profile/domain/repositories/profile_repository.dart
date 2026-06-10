import '../../data/models/profile_response.dart';
import '../../data/models/profile_request.dart';

/// Abstract interface for profile operations.
abstract class ProfileRepository {
  /// Fetches the current user's profile.
  Future<ProfileResponse> getMyProfile();

  /// Saves/updates the current user's profile.
  Future<ProfileResponse> saveProfile(ProfileRequest request);
}
