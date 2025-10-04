import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatro/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
class AuthServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  // SIGN UP
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String profile,
  })
  async {
    UserCredential? result;
    try {
      // Basic input validation
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        throw Exception("Email, password, and name cannot be empty");
      }

      result = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await addUser(
        uid: result.user!.uid,
        name: name.trim(),
        email: result.user!.email ?? "",
        photoUrl: profile,
      );

      return result.user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) log("SignUp Error: ${e.message}", name: 'AuthServices');
      if (result?.user != null) {
        await result!.user!.delete();
      }
      return null;
    } catch (e) {
      if (kDebugMode) log("Unexpected SignUp Error: $e", name: 'AuthServices');
      if (result?.user != null) {
        await result!.user!.delete();
      }
      return null;
    }
  }

  // LOGIN
  Future<User?> loginUser({
    required String email,
    required String password,
  })
  async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) log("Login Error: ${e.message}", name: 'AuthServices');
      return null;
    } catch (e) {
      if (kDebugMode) log("Unexpected Login Error: $e", name: 'AuthServices');
      return null;
    }
  }

  // SIGN OUT
  Future<void> signOut()
  async {
    try {
      await auth.signOut();
    } catch (e) {
      if (kDebugMode) log("SignOut Error: $e", name: 'AuthServices');
      rethrow;
    }
  }

  // ADD USER TO FIRESTORE
  Future<void> addUser({
    required String uid,
    required String name,
    required String email,
    String? photoUrl,
  })
  async {
    try {
      final userModel = UserModel(
        id: uid,
        name: name,
        email: email,
        profile: photoUrl ?? "",
        createdAt: Timestamp.now(),
      );
      await firestore.collection("users").doc(uid).set(
        userModel.toJson(),
        SetOptions(merge: true),
      );
    } catch (e) {
      if (kDebugMode) log("Add User Error: $e", name: 'AuthServices');
      rethrow;
    }
  }

  // RESET PASSWORD
  Future<void> resetPassword(String email)
  async {
    try {
      await auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) log("Reset Password Error: ${e.message}", name: 'AuthServices');
      rethrow;
    } catch (e) {
      if (kDebugMode) log("Unexpected Reset Password Error: $e", name: 'AuthServices');
      rethrow;
    }
  }

  // GET USER DATA
  Future<UserModel?> getUserData(String uid)
  async {
    try {
      DocumentSnapshot doc = await firestore.collection("users").doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      if (kDebugMode) log("Get User Data Error: $e", name: 'AuthServices');
      return null;
    }
  }
}