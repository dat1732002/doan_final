class ProductModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> favoriteUserIds;
  final Map<String, String> comments;
  final List<String> availableSizes;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.favoriteUserIds = const [],
    this.comments = const {},
    this.availableSizes = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'favoriteUserIds': favoriteUserIds,
      'comments': comments,
      'availableSizes': availableSizes,
    };
  }

  List<Comment> get commentsList {
    return comments.entries.map((entry) => Comment(userId: entry.key, text: entry.value)).toList();
  }
}

class Comment {
  final String userId;
  final String text;

  Comment({required this.userId, required this.text});
}