import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class ImagePreview extends StatefulWidget {
  final File filePath;
  const ImagePreview({Key? key, required this.filePath}) : super(key: key);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  bool _rowVisible = true;
  // String imagePath =
  //     'https://9to5mac.com/wp-content/uploads/sites/6/2021/10/Apple_MacBook-Pro_16-inch-Screen_10182021_big_carousel.jpg.large_2x.jpg?quality=82&strip=all&w=1538';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _rowVisible = !_rowVisible;
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: _rowVisible ? 1.0 : 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: IconButton(
                        onPressed: () async {
                          CroppedFile? croppedFile =
                              await ImageCropper().cropImage(
                            sourcePath: widget.filePath.path,
                            // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
                            compressQuality: 100,
                            maxHeight: 700,
                            cropStyle: CropStyle.rectangle,
                            uiSettings: [
                              AndroidUiSettings(
                                toolbarTitle: 'Cropper',
                                toolbarColor: Colors.deepOrange,
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false,
                              ),
                            ],
                            maxWidth: 700,
                            compressFormat: ImageCompressFormat.jpg,
                          );
                        },
                        icon: const Icon(
                          Icons.crop,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 80),
              Expanded(
                flex: 2,
                child: Image.file(
                  widget.filePath,
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
