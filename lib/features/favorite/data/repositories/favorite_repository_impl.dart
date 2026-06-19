import '../../domain/repositories/favorite_repository.dart';
import '../models/fav_list_response.dart';
import '../services/favorite_api_service.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  FavoriteRepositoryImpl({FavoriteApiService? apiService})
    : _apiService = apiService ?? FavoriteApiService();

  final FavoriteApiService _apiService;

  @override
  Future<List<FavListResponse>> getFavorites() => _apiService.getFavorites();

  @override
  Future<void> addToFavorite(int postId) => _apiService.addToFavorite(postId);

  @override
  Future<void> removeFromFavorite(int postId) =>
      _apiService.removeFromFavorite(postId);
}
