import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(UserModel user, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        name: user.name,
        phone: user.phone,
        email: user.email,
        dateOfBirth: user.dateOfBirth,
        role: 'member',
        address: user.address,
      );

      await _firestore
          .collection('users')
          .doc(newUser.id)
          .set(newUser.toJson());
    } catch (e) {
      throw Exception('Error registering user: $e');
    }
  }

  Future<UserModel?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return UserModel(
          id: userCredential.user!.uid,
          name: userData['name'],
          phone: userData['phone'],
          email: userData['email'],
          dateOfBirth: userData['dateOfBirth'],
          role: userData['role'],
          address: userData['address'],
        );
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
    return null;
  }

  Future<List<UserModel>> fetchUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModel(
          id: doc.id,
          name: data['name'],
          phone: data['phone'],
          email: data['email'],
          dateOfBirth: data['dateOfBirth'],
          role: data['role'],
          address: data['address'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  String getCurrentUserId() {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    throw Exception('No user is currently logged in.');
  }

  Future<Map<String, dynamic>> fetchUserDetails(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Error fetching user details: $e');
    }
  }
}
