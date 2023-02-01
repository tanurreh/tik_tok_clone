import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:titto_clone/app/database_services.dart';
import 'package:titto_clone/app/modules/home/models/video_model.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  DatabaseServices db = DatabaseServices();

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    print('video-compression-donwe');
    return compressedVideo!.file;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    print(videoPath);
    Reference ref = _storage.ref().child('videos').child(id);

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadThumbnailToStorage(String id, String videoPath) async {
    Reference ref = _storage.ref('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadVideo(
      String songName, String caption, String videoPath) async {
    String res = 'somethinsg is wrong';
    try {
      String currentuser = _auth.currentUser!.uid;
      DocumentSnapshot userDoc = await db.userCollection.doc(currentuser).get();
      var allDocs = await db.videoCollection.get();
      int len = allDocs.docs.length+1;
      print(len);

      // phir use firebase ma add krta with model
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      print('This iS $videoUrl');

      String thumbnail =
          await _uploadThumbnailToStorage("Video $len", videoPath);
      print('This iS $thumbnail');

      VideoModel video = VideoModel(
        username: (userDoc.data()! as Map<String, dynamic>)['username'],
        uid: currentuser,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilephoto'],
        thumbnail: thumbnail,
      );
      await db.videoCollection.doc('Video $len').set(video.toMap());
      res = 'success';
    } on FirebaseException catch (e) {
      Get.snackbar('Video Not Upload', e.toString());
      res = " video not upload";
    }
    return res;
  }
}
