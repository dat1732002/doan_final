import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new category
  Future<void> createCategory(CategoryModel category) async {
    try {
      await _firestore.collection('categories').add(category.toJson());
    } catch (e) {
      throw Exception('Error creating category: $e');
    }
  }

  // Fetch all categories
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('categories').get();
      return querySnapshot.docs.map((doc) {
        return CategoryModel.fromJson(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Update an existing category
  Future<void> updateCategory(CategoryModel category) async {
    try {
      if (category.isUsed) {
        throw Exception('Cannot update category in use');
      }
      await _firestore
          .collection('categories')
          .doc(category.id)
          .update(category.toJson());
    } catch (e) {
      throw Exception('Error updating category: $e');
    }
  }

  // Delete a category
  Future<void> deleteCategory(String categoryId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('categories').doc(categoryId).get();
      if (doc.exists) {
        CategoryModel category =
            CategoryModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
        if (category.isUsed) {
          throw Exception('Cannot delete category in use');
        }
      }
      await _firestore.collection('categories').doc(categoryId).delete();
    } catch (e) {
      throw Exception('Error deleting category: $e');
    }
  }

  // Mark category as used
  Future<void> markCategoryAsUsed(String categoryId) async {
    try {
      await _firestore
          .collection('categories')
          .doc(categoryId)
          .update({'isUsed': true});
    } catch (e) {
      throw Exception('Error marking category as used: $e');
    }
  }

  // Check if category is used
  Future<bool> isCategoryUsed(String categoryId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('categories').doc(categoryId).get();
      if (doc.exists) {
        CategoryModel category =
            CategoryModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
        return category.isUsed;
      }
      return false;
    } catch (e) {
      throw Exception('Error checking if category is used: $e');
    }
  }
}
