import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/models/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<void> createProduct(ProductModel product) async {

    try {
      await _firestore.collection('products').add({
        'name': product.name,
        'category': product.category,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'favoriteUserIds': [],
        'sizes': product.sizes, // Thêm trường này
      });
    } catch (e) {
      throw Exception('Error creating product: $e');
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.id)
          .update({
        'name': product.name,
        'category': product.category,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'favoriteUserIds': [],
        'sizes': product.sizes, // Thêm trường này
      });
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }

  Future<List<ProductModel>> fetchProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, int> sizes = Map<String, int>.from(data['sizes'] ?? {});

        var sortedSizes = Map.fromEntries(
          sizes.entries.toList()
            ..sort((e1, e2) => int.parse(e1.key).compareTo(int.parse(e2.key))),
        );
        return ProductModel(
          id: doc.id,
          name: data['name'],
          category: data['category'],
          description: data['description'],
          price: data['price'],
          imageUrl: data['imageUrl'],
          favoriteUserIds: List<String>.from(data['favoriteUserIds'] ?? []),
          sizes: sortedSizes,
        );
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
  Future<void> updateProductStock(String productId, Map<String, int> updatedSizes) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .update({'sizes': updatedSizes});
    } catch (e) {
      throw Exception('Error updating product stock: $e');
    }
  }
  Future<void> toggleFavorite(String productId, String userId) async {
    try {
      DocumentReference productRef =
          _firestore.collection('products').doc(productId);
      DocumentSnapshot productSnapshot = await productRef.get();

      if (productSnapshot.exists) {
        List<String> favoriteUserIds =
            List<String>.from(productSnapshot['favoriteUserIds'] ?? []);

        if (favoriteUserIds.contains(userId)) {
          favoriteUserIds.remove(userId);
        } else {
          favoriteUserIds.add(userId);
        }

        await productRef.update({'favoriteUserIds': favoriteUserIds});
      }
    } catch (e) {
      throw Exception('Error toggling favorite: $e');
    }
  }

  Future<String> uploadImage(File image) async {
    try {
      String fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
      Reference storageRef = _storage.ref().child('product_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  Future<ProductModel?> fetchProductDetails(String productId) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, int> sizes = Map<String, int>.from(data['sizes'] ?? {});

        var sortedSizes = Map.fromEntries(
          sizes.entries.toList()
            ..sort((e1, e2) => int.parse(e1.key).compareTo(int.parse(e2.key))),
        );
        return ProductModel(
          id: doc.id,
          name: data['name'],
          category: data['category'],
          description: data['description'],
          price: data['price'],
          imageUrl: data['imageUrl'],
          favoriteUserIds: List<String>.from(data['favoriteUserIds'] ?? []),
          comments: Map<String, String>.from(data['comments'] ?? {}),
          sizes: sortedSizes, // Thêm trường này
        );
      }
    } catch (e) {
      throw Exception('Error fetching product details: $e');
    }
    return null;
  }

  Future<void> addComment(
      String productId, String userId, String comment) async {
    try {
      DocumentReference productRef =
          _firestore.collection('products').doc(productId);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot productSnapshot = await transaction.get(productRef);

        if (productSnapshot.exists) {
          Map<String, dynamic> data =
              productSnapshot.data() as Map<String, dynamic>;
          Map<String, String> comments =
              Map<String, String>.from(data['comments'] ?? {});

          comments[userId] = comment;

          transaction.update(productRef, {'comments': comments});
        } else {
          throw Exception('Product not found');
        }
      });
    } catch (e) {
      throw Exception('Error adding or updating comment: $e');
    }
  }
  Future<void> deleteComment(String productId, String userId, String comment) async {
    try {
      DocumentReference productRef =
      _firestore.collection('products').doc(productId);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot productSnapshot = await transaction.get(productRef);

        if (productSnapshot.exists) {
          Map<String, dynamic> data =
          productSnapshot.data() as Map<String, dynamic>;
          Map<String, String> comments =
          Map<String, String>.from(data['comments'] ?? {});

          String? keyToDelete;
          comments.forEach((key, value) {
            if (key.startsWith(userId) && value == comment) {
              keyToDelete = key;
            }
          });

          if (keyToDelete != null) {
            comments.remove(keyToDelete);
            transaction.update(productRef, {'comments': comments});
          } else {
            throw Exception('Comment not found');
          }
        } else {
          throw Exception('Product not found');
        }
      });
    } catch (e) {
      throw Exception('Error deleting comment: $e');
    }
  }

}
