import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  final File filePath;
  const ImagePreview({Key? key, required this.filePath}) : super(key: key);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  bool _rowVisible = false;
  String imagePath =
      'https://9to5mac.com/wp-content/uploads/sites/6/2021/10/Apple_MacBook-Pro_16-inch-Screen_10182021_big_carousel.jpg.large_2x.jpg?quality=82&strip=all&w=1538';
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
                          // CroppedFile? croppedFile = await ImageCropper()
                          //     .cropImage(
                          //         sourcePath: widget.filePath!,
                          //         cropStyle: CropStyle.rectangle);
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
              Image.file(widget.filePath, fit: BoxFit.cover)
            ],
          ),
        ),
      ),
    );
  }
}
