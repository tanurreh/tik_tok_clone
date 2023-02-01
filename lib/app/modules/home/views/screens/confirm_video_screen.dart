import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:titto_clone/app/data/constants.dart';
import 'package:titto_clone/app/modules/home/controllers/video_controller.dart';
import 'package:titto_clone/app/modules/home/views/widgets/textinputfeild.dart';
import 'package:video_player/video_player.dart';

class ConfirmVideoScreen extends StatefulWidget {
  final File videofile;
  final String videopath;
  const ConfirmVideoScreen({
    Key? key,
    required this.videofile,
    required this.videopath,
  }) : super(key: key);

  @override
  State<ConfirmVideoScreen> createState() => _ConfirmVideoScreenState();
}

class _ConfirmVideoScreenState extends State<ConfirmVideoScreen> {
  late VideoPlayerController controller;
  TextEditingController _songController = TextEditingController();
  TextEditingController _captionController = TextEditingController();
  bool isLoading = false;

  final UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videofile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  uploadVideo() async {
    setState(() {
      isLoading = true;
    });
    String res = await uploadVideoController.uploadVideo(
        _songController.text, _captionController.text, widget.videopath);
    if (res == 'success') {
      setState(() {
        isLoading = false;
      });
      Get.back();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: VideoPlayer(controller),
            ),
            const SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _songController,
                      labelText: 'Song Name',
                      icon: Icons.music_note,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _captionController,
                      labelText: 'Caption',
                      icon: Icons.closed_caption,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  isLoading ? CircularProgressIndicator(
                            color: CustomColor.borderColor,
                          ): ElevatedButton(
                      onPressed: () {
                        uploadVideo();
                      },
                      child:  const Text(
                        'Share!', 
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
