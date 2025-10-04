import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profile;
  final Timestamp? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profile,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "profile": profile ?? "",
    "createdAt": createdAt ?? FieldValue.serverTimestamp(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"]?.toString() ?? "",
    name: json["name"]?.toString() ?? "",
    email: json["email"]?.toString() ?? "",
    profile: json["profile"]?.toString(),
    createdAt: json["createdAt"] as Timestamp?,
  );
}