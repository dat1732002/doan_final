import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/models/cart_item_model.dart';
import 'package:ecommerce_flutter/models/order_model.dart';
import 'package:ecommerce_flutter/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromJson(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
      });
    } catch (e) {
      throw Exception('Error updating order status: $e');
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
    } catch (e) {
      throw Exception('Error deleting order: $e');
    }
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists) {
        return OrderModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error fetching order: $e');
    }
  }

  Future<void> moveCartToOrders(List<CartItemModel> items) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently logged in.');
      }
      String userId = user.uid;

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw Exception('User not found');
      }
      UserModel userModel =
          UserModel.fromJson(userDoc.data() as Map<String, dynamic>, userId);

      await _firestore.collection('orders').add({
        'userId': userId,
        'items': items.map((item) => item.toJson()).toList(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'totalAmount':
            items.fold(0.0, (sum, item) => sum + (item.quantity * item.price)),
        'paymentMethod': 'Cash on Delivery',
        'customerName': userModel.name,
        'customerPhone': userModel.phone,
        'customerAddress': userModel.address,
      });
    } catch (e) {
      throw Exception('Error moving cart to orders: $e');
    }
  }

  Stream<List<OrderModel>> getAllOrders() {
    return _firestore.collection('orders').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromJson(doc.data(), doc.id);
      }).toList();
    });
  }
}
