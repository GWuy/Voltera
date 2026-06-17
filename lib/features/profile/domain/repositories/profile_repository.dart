import 'dart:io';

import '../../data/models/profile_response.dart';
import '../../data/models/profile_request.dart';

abstract class ProfileRepository {
  Future<ProfileResponse> getMyProfile();
  Future<ProfileResponse> saveProfile(ProfileRequest request);
  Future<String> uploadAvatar(File imageFile);
  Future<void> logout(String username);
}
