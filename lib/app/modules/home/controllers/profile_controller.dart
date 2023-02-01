import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:titto_clone/app/database_services.dart';
import 'package:titto_clone/app/modules/home/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  DatabaseServices db = DatabaseServices();
  final AuthController _authController = Get.find<AuthController>();
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  Rx<String> _uid = "".obs;

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    List<String> thumbnails = [];
    var myVideos = await
        db.videoCollection
        .where('uid', isEqualTo: _uid.value)
        .get();

    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }

    DocumentSnapshot userDoc =
        await db.userCollection.doc(_uid.value).get();
    final userData = userDoc.data()! as dynamic;
    String name = userData['username'];
    String profilePhoto = userData['profilephoto'];
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    // for (var item in myVideos.docs) {
    //   likes += (item.data()!['likes'] as List).length;
    // }
    var followerDoc = await db.userCollection
        .doc(_uid.value)
        .collection('followers')
        .get();
    var followingDoc = await  db.userCollection
        .doc(_uid.value)
        .collection('following')
        .get();
    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

     db.userCollection
        .doc(_uid.value)
        .collection('followers')
        .doc(_authController.user!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profilephoto': profilePhoto,
      'username': name,
      'thumbnails': thumbnails,
    };
    update();
  }

  followUser() async {
    var doc = await  db.userCollection
        .doc(_uid.value)
        .collection('followers')
        .doc(_authController.user!.uid)
        .get();

    if (!doc.exists) {
      await  db.userCollection
          .doc(_uid.value)
          .collection('followers')
          .doc(_authController.user!.uid)
          .set({});
      await  db.userCollection
          .doc(_authController.user!.uid)
          .collection('following')
          .doc(_uid.value)
          .set({});
      _user.value.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );
    } else {
      await db.userCollection
          .doc(_uid.value)
          .collection('followers')
          .doc(_authController.user!.uid)
          .delete();
      await db.userCollection
          .doc(_authController.user!.uid)
          .collection('following')
          .doc(_uid.value)
          .delete();
      _user.value.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
    }
    _user.value.update('isFollowing', (value) => !value);
    update();
  }
}