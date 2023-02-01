import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:titto_clone/app/data/theme.dart';
import 'package:titto_clone/app/modules/home/controllers/auth_controller.dart';
import 'package:titto_clone/app/modules/home/views/screens/auth/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(GetMaterialApp(
      defaultTransition: Transition.rightToLeft,
      debugShowCheckedModeBanner: false,
      title: "Tik tok Clone",
      theme:  primaryTheme,
      home: LoginScreen(),
    ));
}

