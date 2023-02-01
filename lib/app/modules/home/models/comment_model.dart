import 'dart:convert';

class Comment {
  String username;
  String comment;
  dynamic datePublished;
  List likes;
  String profilePhoto;
  String uid;
  String id;

  Comment({
    required this.username,
    required this.comment,
    required this.datePublished,
    required this.likes,
    required this.profilePhoto,
    required this.uid,
    required this.id,
  });

  


  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'username': username});
    result.addAll({'comment': comment});
    result.addAll({'datePublished': datePublished});
    result.addAll({'likes': likes});
    result.addAll({'profilePhoto': profilePhoto});
    result.addAll({'uid': uid});
    result.addAll({'id': id});
  
    return result;
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      username: map['username'] ?? '',
      comment: map['comment'] ?? '',
      datePublished: map['datePublished'] ?? null,
      likes: List.from(map['likes']),
      profilePhoto: map['profilePhoto'] ?? '',
      uid: map['uid'] ?? '',
      id: map['id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) => Comment.fromMap(json.decode(source));
}
