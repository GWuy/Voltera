import 'package:flutter/material.dart';
import '../../data/favorite_service.dart';
import '../../data/models/fav_list_response.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteService _service = FavoriteService();
  
  List<FavListResponse> _favorites = [];
  bool _isLoading = false;

  List<FavListResponse> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Set<int> get favoritePostIds => _favorites.map((e) => e.postId).toSet();

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();
    try {
      _favorites = await _service.getFavorites();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(int postId) {
    return favoritePostIds.contains(postId);
  }

  Future<bool> toggleFavorite(int postId, {String? title, double? price, String? thumbnail}) async {
    final currentlyFavorite = isFavorite(postId);
    try {
      if (currentlyFavorite) {
        await _service.removeFromFavorite(postId);
        _favorites.removeWhere((element) => element.postId == postId);
      } else {
        await _service.addToFavorite(postId);
        // Optimistically add to list if we have info, otherwise reload
        if (title != null && price != null) {
          _favorites.add(FavListResponse(
            userId: 0, // Not strictly needed for UI display
            postId: postId,
            postTitle: title,
            price: price,
            thumbnailUrl: thumbnail,
          ));
        } else {
          await loadFavorites();
        }
      }
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      return false;
    }
  }
}
