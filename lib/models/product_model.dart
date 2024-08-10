class ProductModel {
   String id;
   String name;
   String category;
   String description;
   double price;
   String imageUrl;
   List<String> favoriteUserIds;
   Map<String, String> comments;
   List<String> availableSizes;

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

  // Convert a ProductModel instance to a Map<String, dynamic> for JSON serialization
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

  // Create a ProductModel instance from a Map<String, dynamic>
  factory ProductModel.fromJson(String id, Map<String, dynamic> json) {
    return ProductModel(
      id: id,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      favoriteUserIds: List<String>.from(json['favoriteUserIds'] ?? []),
      comments: Map<String, String>.from(json['comments'] ?? {}),
      availableSizes: List<String>.from(json['availableSizes'] ?? []),
    );
  }

  // Convert comments map to a list of Comment objects
  List<Comment> get commentsList {
    return comments.entries.map(
          (entry) => Comment(userId: entry.key, text: entry.value),
    ).toList();
  }
}

// Assuming you have a Comment class defined like this
class Comment {
   String userId;
   String text;

  Comment({
    required this.userId,
    required this.text,
  });

  // Convert a Comment instance to a Map<String, dynamic> for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'text': text,
    };
  }

  // Create a Comment instance from a Map<String, dynamic>
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userId: json['userId'] as String,
      text: json['text'] as String,
    );
  }
}
