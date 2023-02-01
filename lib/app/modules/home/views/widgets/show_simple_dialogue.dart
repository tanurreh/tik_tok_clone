import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:titto_clone/app/image_services.dart';

showOptionsDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      children: [
        SimpleDialogOption(
          onPressed: () {
            VideoServices().picVideo(ImageSource.gallery, context);
          },
          child: Row(
            children: const [
              Icon(Icons.image),
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Text(
                  'Gallery',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
             VideoServices().picVideo(ImageSource.camera, context);
          },
          child: Row(
            children: const [
              Icon(Icons.camera_alt),
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Text(
                  'Camera',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(),
          child: Row(
            children: const [
              Icon(Icons.cancel),
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
