import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Handle successful login
    } catch (e) {
      // Handle login errors
      print('Login Error: $e');
    }
  }

  Future<void> storeUserDetails(
      String username, String email, String password, File imageFile) async {
    try {
      String fileName = 'profile_$username.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_pictures/$fileName');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot storageSnapshot = await uploadTask;
      String downloadURL = await storageSnapshot.ref.getDownloadURL();

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userID = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(userID).set({
        'username': username,
        'email': email,
        'bio': '',
        'profilePictureURL': downloadURL,
        'followersCount': 0,
        'followingCount': 0,
        'postsCount': 0,
        'createdAt': DateTime.now(),
        'followers': [], // Initialize empty followers array
        'following': [], // Initialize empty following array
      });

      print("User details added successfully!");
    } catch (error) {
      print("Failed to add user details: $error");
    }
  }

  Future<Map<String, dynamic>?> getUserDetails(String userID) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        return userData;
      } else {
        print('User not found.');
        return null;
      }
    } catch (error) {
      print('Failed to get user details: $error');
      return null;
    }
  }

  Future<void> updateUserDetails(String userId, String username, String email,
      String bio, File? imageFile) async {
    try {
      Map<String, dynamic> updateData = {
        'username': username,
        'email': email,
        'bio': bio,
      };

      if (imageFile != null) {
        updateData['profilePhoto'] = await uploadImage(imageFile, userId);
      }

      await FirebaseFirestore.instance.collection('users').doc(userId).update(updateData);
    } catch (error) {
      print('Error updating user details: $error');
    }
  }

  Future<String> uploadImage(File imageFile, String userId) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_pictures/$imageFile');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot storageSnapshot = await uploadTask;
      String downloadURL = await storageSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  // Follow Function
  Future<void> followUser(String currentUserId, String followedUserId) async {
    try {
      // Update the current user's following list
      await _db.collection('users').doc(currentUserId).update({
        'following': FieldValue.arrayUnion([followedUserId]),
        'followingCount': FieldValue.increment(1),
      });

      // Update the followed user's followers list
      await _db.collection('users').doc(followedUserId).update({
        'followers': FieldValue.arrayUnion([currentUserId]),
        'followersCount': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error following user: $e');
    }
  }

  // Unfollowing Function
  Future<void> unfollowUser(
      String currentUserId, String followedUserId) async {
    try {
      // Update the current user's following list
      await _db.collection('users').doc(currentUserId).update({
        'following': FieldValue.arrayRemove([followedUserId]),
        'followingCount': FieldValue.increment(-1),
      });

      // Update the followed user's followers list
      await _db.collection('users').doc(followedUserId).update({
        'followers': FieldValue.arrayRemove([currentUserId]),
        'followersCount': FieldValue.increment(-1),
      });
    } catch (e) {
      print('Error unfollowing user: $e');
    }
  }

  Future<List<String>> getFollowers(String userId) async {
    List<String> followerIds = [];

    try {
      DocumentSnapshot snapshot = await _db.collection('users').doc(userId).get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          followerIds = List<String>.from(data['followers'] ?? []);
        }
      }
    } catch (e) {
      print('Error retrieving followers: $e');
    }

    return followerIds;
  }

  Future<List<String>> getFollowing(String userId) async {
    List<String> followingIds = [];

    try {
      DocumentSnapshot snapshot = await _db.collection('users').doc(userId).get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          followingIds = List<String>.from(data['following'] ?? []);
        }
      }
    } catch (e) {
      print('Error retrieving following: $e');
    }

    return followingIds;
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
