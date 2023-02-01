import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:titto_clone/app/database_services.dart';
import 'package:titto_clone/app/modules/home/controllers/auth_controller.dart';
import 'package:titto_clone/app/modules/home/models/video_model.dart';

class VideoController extends GetxController {
  DatabaseServices db = DatabaseServices();
  final AuthController _authController = Get.find<AuthController>();
  final Rx<List<VideoModel>> _videos = Rx<List<VideoModel>>([]);
  List<VideoModel> get video => _videos.value;

  @override
  void onInit() {
    super.onInit();
    _videos
        .bindStream(db.videoCollection.orderBy('id', descending: true).
        
        snapshots().map((QuerySnapshot query) {
      List<VideoModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(VideoModel.fromMap(element.data() as Map<String, dynamic>));
      }
      return retVal;
    }));
  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await db.videoCollection.doc(id).get();
    var uid = _authController.user!.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await db.videoCollection.doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await db.videoCollection.doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
