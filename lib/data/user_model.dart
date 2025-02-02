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

  // Convert a UserModel into a Map object for SQLite operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,  // This field is optional because it is auto-generated
      'name': name,
      'email': email,
      'profilePic': profilePic,
    };
  }

  // Convert a Map object back into a UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      profilePic: map['profilePic'],
    );
  }
}
