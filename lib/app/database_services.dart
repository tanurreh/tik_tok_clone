import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class DatabaseServices {
    CollectionReference userCollection =
    FirebaseFirestore.instance.collection('Users');
    CollectionReference videoCollection =
    FirebaseFirestore.instance.collection('videos');


}
