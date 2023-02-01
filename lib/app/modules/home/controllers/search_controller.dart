import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:titto_clone/app/database_services.dart';
import 'package:titto_clone/app/modules/home/models/user_model.dart';

class SearchController extends GetxController {
  DatabaseServices db = DatabaseServices();
  final Rx<List<UserModel>> _searchedUsers = Rx<List<UserModel>>([]);

  List<UserModel> get searchedUsers => _searchedUsers.value;

  searchUser(String typedUser) async {
    _searchedUsers.bindStream(
      db.userCollection
        .where('username', isGreaterThanOrEqualTo: typedUser)
        .snapshots()
        .map((QuerySnapshot query) {
      List<UserModel> retVal = [];
      for (var elem in query.docs) {
        retVal.add(UserModel.fromMap(elem.data() as Map<String, dynamic>));
      }
      return retVal;
      
    }));
  }


}