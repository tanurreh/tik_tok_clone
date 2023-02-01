import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:titto_clone/app/database_services.dart';
import 'package:titto_clone/app/modules/home/models/user_model.dart';
import 'package:titto_clone/app/modules/home/views/screens/auth/login_screen.dart';
import 'package:titto_clone/app/modules/home/views/screens/home_page_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  DatabaseServices db = DatabaseServices();
  late Rx<User?> _user;
  User? get user => _user.value;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(_auth.currentUser);
    _user.bindStream(_auth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  //picimage function
  late Rx<File?> _pickedImage;

  File? get profilePhoto => _pickedImage.value;

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile Picture',
          'You have successfully selected your profile picture!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  //upload image to firestoreStorage

  Future<String> imageUpload(File image) async {
    var snapshot = await _storage
        .ref()
        .child('profilepicture')
        .child('images/${DateTime.now()}')
        .putFile(image);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // registeration of user
  Future<void> registerUser(
      String username, String emailAddress, String password, File? file) async {
    try {
      if (username.isNotEmpty &&
          emailAddress.isNotEmpty &&
          password.isNotEmpty &&
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: emailAddress, password: password);
        // upload image to firestorage
        String downloadUrl = await imageUpload(file);
        //Creating Model to enter in firestore
        UserModel user = UserModel(
            uid: cred.user!.uid,
            username: username,
            email: emailAddress,
            profilephoto: downloadUrl);
        await db.userCollection.doc(cred.user!.uid).set(user.toMap());
      } else {
        Get.snackbar('Data Feilds are empty', "Please Input all feilds");
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Unenale to Create User', e.toString());
    }
  }

  Future<void> loginUser(String emailAddress, String password) async {
    try {
      if (emailAddress.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: emailAddress, password: password);
        print('log in sucessfull');
      } else {
        Get.snackbar('Feilds are Empty', "Please Complete all the feild ");
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Authentication Failed', e.toString());
    }
  }

  signOut() async {
    await _auth.signOut();
  }
}
