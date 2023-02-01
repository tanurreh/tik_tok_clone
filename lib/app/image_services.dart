import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:titto_clone/app/modules/home/views/screens/confirm_video_screen.dart';

class VideoServices {
  Future<void> picVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Get.to(() => ConfirmVideoScreen(videofile: File(video.path), videopath: video.path,

      ));
    }
  }
}
