class CartItemModel {
  final String productId;
  int quantity;
  final String imageUrl;
  final String productName;
  final double price;
  final String size;

  CartItemModel({
    required this.productId,
    required this.quantity,
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.size,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'productName': productName,
      'price': price,
      'size': size,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'],
      quantity: json['quantity'],
      imageUrl: json['imageUrl'],
      productName: json['productName'],
      price: json['price'],
      size: json['size'],
    );
  }
}