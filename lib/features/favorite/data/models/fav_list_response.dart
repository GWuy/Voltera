import 'dart:convert';

class FavListResponse {
  final int userId;
  final int postId;
  final String postTitle;
  final double price;
  final String? thumbnailUrl;

  FavListResponse({
    required this.userId,
    required this.postId,
    required this.postTitle,
    required this.price,
    this.thumbnailUrl,
  });

  factory FavListResponse.fromJson(Map<String, dynamic> json) {
    return FavListResponse(
      userId: json['userId'] as int,
      postId: json['postId'] as int,
      postTitle: json['postTitle'] as String,
      price: (json['price'] as num).toDouble(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'postId': postId,
      'postTitle': postTitle,
      'price': price,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}
