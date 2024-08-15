import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/models/category_model.dart';
import 'package:ecommerce_flutter/models/product_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createCategory(CategoryModel category) async {
    try {
      await _firestore.collection('categories').add(category.toJson());
    } catch (e) {
      throw Exception('Error creating category: $e');
    }
  }

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

  Future<void> updateCategory(CategoryModel category) async {
    try {
      QuerySnapshot categoryQuery = await _firestore
          .collection('categories')
          .where('name', isEqualTo: category.name)
          .get();

      if (categoryQuery.docs.isEmpty) {
        throw Exception('Category not found');
      }

      String categoryId = categoryQuery.docs.first.id;

      await _firestore
          .collection('categories')
          .doc(categoryId)
          .update(category.toJson());

      await _updateCategoryInProducts(category);
    } catch (e) {
      throw Exception('Error updating category: $e');
    }
  }

  Future<void> deleteCategory(String categoryName) async {
    try {
      QuerySnapshot categoryQuery = await _firestore
          .collection('categories')
          .where('name', isEqualTo: categoryName)
          .get();

      if (categoryQuery.docs.isEmpty) {
        throw Exception('Category not found');
      }

      String categoryId = categoryQuery.docs.first.id;
      CategoryModel category = CategoryModel.fromJson(
          categoryId, categoryQuery.docs.first.data() as Map<String, dynamic>);

      if (category.isUsed) {
        await _firestore.collection('categories').doc(categoryId).delete();

        await _removeCategoryFromProducts(categoryName);
      } else {
        throw Exception('Category is not in use. Cannot delete.');
      }
    } catch (e) {
      throw Exception('Error deleting category: $e');
    }
  }

  Future<void> markCategoryAsUsed(String categoryName) async {
    try {
      QuerySnapshot categoryQuery = await _firestore
          .collection('categories')
          .where('name', isEqualTo: categoryName)
          .get();

      if (categoryQuery.docs.isEmpty) {
        throw Exception('Category not found');
      }

      String categoryId = categoryQuery.docs.first.id;

      await _firestore
          .collection('categories')
          .doc(categoryId)
          .update({'isUsed': true});
    } catch (e) {
      throw Exception('Error marking category as used: $e');
    }
  }

  Future<bool> isCategoryUsed(String categoryName) async {
    try {
      QuerySnapshot categoryQuery = await _firestore
          .collection('categories')
          .where('name', isEqualTo: categoryName)
          .get();

      if (categoryQuery.docs.isEmpty) {
        return false;
      }

      String categoryId = categoryQuery.docs.first.id;
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

  Future<void> _updateCategoryInProducts(CategoryModel category) async {
    try {
      QuerySnapshot productQuery = await _firestore
          .collection('products')
          .where('category', isEqualTo: category.name)
          .get();

      for (DocumentSnapshot doc in productQuery.docs) {
        ProductModel product = ProductModel.fromJson(
            doc.id, doc.data() as Map<String, dynamic>);
        product.category = category.name;

        await _firestore
            .collection('products')
            .doc(product.id)
            .update(product.toJson());
      }
    } catch (e) {
      throw Exception('Error updating category in products: $e');
    }
  }

  Future<void> _removeCategoryFromProducts(String categoryName) async {
    try {
      QuerySnapshot productQuery = await _firestore
          .collection('products')
          .where('category', isEqualTo: categoryName)
          .get();

      for (DocumentSnapshot doc in productQuery.docs) {
        ProductModel product = ProductModel.fromJson(
            doc.id, doc.data() as Map<String, dynamic>);
        product.category = '';

        await _firestore
            .collection('products')
            .doc(product.id)
            .update(product.toJson());
      }
    } catch (e) {
      throw Exception('Error removing category from products: $e');
    }
  }
}
