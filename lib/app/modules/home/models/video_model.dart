import 'dart:convert';

class VideoModel {
  String username;
  String uid;
  String id;
  List likes;
  int commentCount;
  int shareCount;
  String songName;
  String caption;
  String videoUrl;
  String thumbnail;
  String profilePhoto;

  VideoModel({
    required this.username,
    required this.uid,
    required this.id,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.songName,
    required this.caption,
    required this.videoUrl,
    required this.thumbnail,
    required this.profilePhoto,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'username': username});
    result.addAll({'uid': uid});
    result.addAll({'id': id});
    result.addAll({'likes': likes});
    result.addAll({'commentCount': commentCount});
    result.addAll({'shareCount': shareCount});
    result.addAll({'songName': songName});
    result.addAll({'caption': caption});
    result.addAll({'videoUrl': videoUrl});
    result.addAll({'thumbnail': thumbnail});
    result.addAll({'profilePhoto': profilePhoto});
  
    return result;
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      id: map['id'] ?? '',
      likes: List.from(map['likes']),
      commentCount: map['commentCount']?.toInt() ?? 0,
      shareCount: map['shareCount']?.toInt() ?? 0,
      songName: map['songName'] ?? '',
      caption: map['caption'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      profilePhoto: map['profilePhoto'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoModel.fromJson(String source) => VideoModel.fromMap(json.decode(source));
}
