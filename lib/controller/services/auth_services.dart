import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatro/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ------------------ SIGN UP ------------------
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String profile,
  }) async {
    UserCredential? result;
    try {
      result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await addUser(
        uid: result.user!.uid,
        name: name,
        email: result.user!.email ?? "",
        photoUrl: profile,
      );

      return result.user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print("SignUp Error: ${e.message}");
      if (result?.user != null) {
        await result!.user!.delete();
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Unexpected SignUp Error: $e");
      if (result?.user != null) {
        await result!.user!.delete();
      }
      return null;
    }
  }

  // ------------------ LOGIN ------------------
  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print("Login Error: ${e.message}");
      return null;
    } catch (e) {
      if (kDebugMode) print("Unexpected Login Error: $e");
      return null;
    }
  }

  // ------------------ GOOGLE SIGN IN ------------------
  Future<User?> signInWithGoogle() async {
    UserCredential? result;
    try {
      final googleProvider = GoogleAuthProvider();
      result = await auth.signInWithProvider(googleProvider);

      if (result.additionalUserInfo?.isNewUser ?? false) {
        await addUser(
          uid: result.user!.uid,
          name: result.user!.displayName ?? "",
          email: result.user!.email ?? "",
          photoUrl: result.user!.photoURL,
        );
      }
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print("Google SignIn Error: ${e.message}");
      if (result != null && result.user != null && (result.additionalUserInfo?.isNewUser ?? false)) {
        await result.user!.delete();
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Unexpected Google SignIn Error: $e");
      if (result != null && result.user != null && (result.additionalUserInfo?.isNewUser ?? false)) {
        await result.user!.delete();
      }
      return null;
    }
  }

  // ------------------ GUEST SIGN IN ------------------
  Future<User?> continueAsGuest() async {
    UserCredential? result;
    try {
      result = await auth.signInAnonymously();

      if (result.additionalUserInfo?.isNewUser ?? false) {
        await addUser(
          uid: result.user!.uid,
          name: "Guest-${result.user!.uid.substring(0, 5)}",
          email: "",
        );
      }
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print("Guest SignIn Error: ${e.message}");
      if (result != null && result.user != null && (result.additionalUserInfo?.isNewUser ?? false)) {
        await result.user!.delete();
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Unexpected Guest SignIn Error: $e");
      if (result != null && result.user != null && (result.additionalUserInfo?.isNewUser ?? false)) {
        await result.user!.delete();
      }
      return null;
    }
  }

  // ------------------ ADD USER TO FIRESTORE ------------------
  Future<void> addUser({
    required String uid,
    required String name,
    required String email,
    String? photoUrl,
  }) async {
    await firestore.collection("users").doc(uid).set({
      "id": uid,
      "name": name,
      "email": email,
      "profile": photoUrl ?? "",
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)); // prevents overwriting
  }

  // ------------------ GET USER DATA ------------------
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await firestore.collection("users").doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Get User Data Error: $e");
      return null;
    }
  }
}
