class ProductModel {
  String id;
  String name;
  String category;
  String description;
  double price;
  String imageUrl;
  List<String> favoriteUserIds;
  Map<String, String> comments;
  Map<String, int> sizes;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.favoriteUserIds = const [],
    this.comments = const {},
    this.sizes = const {},
  });

  // Phương thức copyWith để tạo một bản sao của ProductModel với các giá trị được cập nhật
  ProductModel copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    double? price,
    String? imageUrl,
    List<String>? favoriteUserIds,
    Map<String, String>? comments,
    List<String>? availableSizes,
    Map<String, int>? sizes,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      favoriteUserIds: favoriteUserIds ?? this.favoriteUserIds,
      comments: comments ?? this.comments,
      sizes: sizes ?? this.sizes,
    );
  }

  // Chuyển đổi ProductModel thành Map<String, dynamic> để dùng trong JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'favoriteUserIds': favoriteUserIds,
      'comments': comments,
      'size': sizes,
    };
  }

  // Tạo một instance của ProductModel từ Map<String, dynamic>
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
      sizes: Map<String, int>.from(json['size'] ?? {}),
    );
  }

  // Chuyển đổi map comments thành danh sách các đối tượng Comment
  List<Comment> get commentsList {
    return comments.entries.map(
          (entry) => Comment(userId: entry.key, text: entry.value),
    ).toList();
  }

  // Chuyển đổi map size thành danh sách các đối tượng Size
  List<Size> get sizeList {
    return sizes.entries.map(
          (entry) => Size(size: entry.key, quantity: entry.value),
    ).toList();
  }
}

class Comment {
  String userId;
  String text;

  Comment({
    required this.userId,
    required this.text,
  });

  // Chuyển đổi Comment thành Map<String, dynamic> để dùng trong JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'text': text,
    };
  }

  // Tạo một instance của Comment từ Map<String, dynamic>
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userId: json['userId'] as String,
      text: json['text'] as String,
    );
  }
}

class Size {
  String size;
  int quantity;

  Size({
    required this.size,
    required this.quantity,
  });

  // Chuyển đổi Size thành Map<String, dynamic> để dùng trong JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'quantity': quantity,
    };
  }

  // Tạo một instance của Size từ Map<String, dynamic>
  factory Size.fromJson(Map<String, dynamic> json) {
    return Size(
      size: json['size'] as String,
      quantity: json['quantity'] as int,
    );
  }
}
