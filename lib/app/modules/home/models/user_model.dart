import 'dart:convert';

class UserModel {
  String uid;
  String username;
  String email;
  String profilephoto;
  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.profilephoto,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'uid': uid});
    result.addAll({'username': username});
    result.addAll({'email': email});
    result.addAll({'profilephoto': profilephoto});
  
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      profilephoto: map['profilephoto'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
