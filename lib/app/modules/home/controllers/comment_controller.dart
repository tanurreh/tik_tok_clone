import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:titto_clone/app/database_services.dart';
import 'package:titto_clone/app/modules/home/controllers/auth_controller.dart';
import 'package:titto_clone/app/modules/home/models/comment_model.dart';

class CommentController extends GetxController {
  DatabaseServices db = DatabaseServices();
  final AuthController _authController = Get.find<AuthController>();

  final Rx<List<Comment>> _comment = Rx<List<Comment>>([]);
  List<Comment> get comment => _comment.value;

  String _postId = "";

  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {
    _comment.bindStream(
      db.videoCollection
          .doc(_postId)
          .collection('comments')
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<Comment> retValue = [];
          for (var element in query.docs) {
            retValue.add(Comment.fromMap(element.data() as Map<String, dynamic>));
          }
          return retValue;
        },
      ),
    );
  }

  postComment(String commentText) async {
    try {
      DocumentSnapshot userDoc =
          await db.userCollection.doc(_authController.user!.uid).get();
      var allDocs =
          await db.videoCollection.doc(_postId).collection('comments').get();
      int len = allDocs.docs.length;
      Comment comment = Comment(
        username: (userDoc.data()! as dynamic)['username'],
        comment: commentText.trim(),
        datePublished: DateTime.now(),
        likes: [],
        profilePhoto: (userDoc.data()! as dynamic)['profilephoto'],
        uid: _authController.user!.uid,
        id: 'Comment $len',
      );
      await db.videoCollection
          .doc(_postId)
          .collection('comments')
          .doc('Comment $len')
          .set(
            comment.toMap(),
          );
      DocumentSnapshot doc = await db.videoCollection.doc(_postId).get();
      await db.videoCollection.doc(_postId).update({
        'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
      });
    } on FirebaseException catch (e) {
      Get.snackbar("Comment Not Added", e.toString());
    }
  }

    likeComment(String id) async {
    var uid = _authController.user!.uid;
    DocumentSnapshot doc = await db.videoCollection
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await db.videoCollection
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await db.videoCollection
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
