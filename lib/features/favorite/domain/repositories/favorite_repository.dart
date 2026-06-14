import 'package:voltera/features/favorite/data/models/fav_list_response.dart';

abstract class FavoriteRepository {
  Future<List<FavListResponse>> getFavorites();
  Future<void> addToFavorite(int postId);
  Future<void> removeFromFavorite(int postId);
}
