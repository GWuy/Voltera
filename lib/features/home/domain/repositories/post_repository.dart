import 'package:voltera/features/home/data/models/post_response.dart';


/// Abstract interface for post/listing operations.
abstract class PostRepository {
  /// Fetches all approved posts.
  Future<List<PostResponse>> getAllPosts({String status = 'APPROVE'});

  /// Fetches vehicle-only posts.
  Future<List<PostResponse>> getVehiclePosts();

  /// Fetches battery-only posts.
  Future<List<PostResponse>> getBatteryPosts();
}
