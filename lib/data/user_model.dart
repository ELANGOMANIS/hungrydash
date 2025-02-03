class UserModel {
  final int? id;
  final String name;
  final String email;
  final String profilePic;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.profilePic,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePic': profilePic,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      profilePic: map['profilePic'],
    );
  }
}
