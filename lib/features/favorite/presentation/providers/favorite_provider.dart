import 'package:flutter/material.dart';
import '../../data/models/fav_list_response.dart';
import '../../domain/repositories/favorite_repository.dart';

class FavoriteProvider extends ChangeNotifier {
  FavoriteProvider({required FavoriteRepository repository})
    : _repository = repository;

  final FavoriteRepository _repository;

  List<FavListResponse> _favorites = [];
  bool _isLoading = false;

  List<FavListResponse> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Set<int> get favoritePostIds => _favorites.map((e) => e.postId).toSet();

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();
    try {
      _favorites = await _repository.getFavorites();
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

  Future<bool> toggleFavorite(
    int postId, {
    String? title,
    double? price,
    String? thumbnail,
  }) async {
    final currentlyFavorite = isFavorite(postId);
    try {
      if (currentlyFavorite) {
        await _repository.removeFromFavorite(postId);
        _favorites.removeWhere((element) => element.postId == postId);
      } else {
        await _repository.addToFavorite(postId);
        if (title != null && price != null) {
          _favorites.add(
            FavListResponse(
              userId: 0,
              postId: postId,
              postTitle: title,
              price: price,
              thumbnailUrl: thumbnail,
            ),
          );
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
