import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String? id;
  final String userId;
  final String status;
  final DateTime createdAt;
  final double totalAmount;
  final String? paymentMethod;
  final String? customerName;
  final String? customerPhone;
  final String? customerAddress;
  final List<OrderItem> items;

  OrderModel({
    this.id,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.totalAmount,
    this.paymentMethod,
    this.customerName,
    this.customerPhone,
    this.customerAddress,
    required this.items,
  });

factory OrderModel.fromJson(Map<String, dynamic> json, String id) {
    return OrderModel(
      id: id,
      userId: json['userId'] ?? '',
      status: json['status'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      paymentMethod: json['paymentMethod'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerAddress: json['customerAddress'],
      items: (json['items'] as List?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final String imageUrl;
  final String size; 

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.size,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      size: json['size'] ?? '', 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
      'size': size,
    };
  }
}
