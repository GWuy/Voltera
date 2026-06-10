import '../../domain/repositories/post_repository.dart';
import '../models/post_response.dart';
import '../services/post_api_service.dart';

/// Concrete implementation of [PostRepository].
class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({PostApiService? apiService})
      : _apiService = apiService ?? PostApiService();

  final PostApiService _apiService;

  @override
  Future<List<PostResponse>> getAllPosts({String status = 'APPROVE'}) =>
      _apiService.getAllPosts(status: status);

  @override
  Future<List<PostResponse>> getVehiclePosts() =>
      _apiService.getVehiclePosts();

  @override
  Future<List<PostResponse>> getBatteryPosts() =>
      _apiService.getBatteryPosts();
}
