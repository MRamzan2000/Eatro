class UserModel {
  final String id;
  final String name;
  final String email;
  final String provider;
  final String? avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.provider,
    this.avatar,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "provider": provider,
    "avatar": avatar,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"] ?? "",
    name: json["name"] ?? "",
    email: json["email"] ?? "",
    provider: json["provider"] ?? "",
    avatar: json["avatar"],
  );
}