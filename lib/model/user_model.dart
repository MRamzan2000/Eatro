class UserModel {
  final String id;
  final String name;
  final String email;
  final String profile;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profile,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "profile": profile,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"] ?? "",
    name: json["name"] ?? "",
    email: json["email"] ?? "",
    profile: json["profile"] ?? "",
  );
}
