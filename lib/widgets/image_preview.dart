import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_sobot_demo/common/lists.dart';
import 'package:whatsapp_sobot_demo/widgets/action_bar.dart';

class ImagePreview extends StatefulWidget {
  final List<File> fileArray;
  const ImagePreview({Key? key, required this.fileArray}) : super(key: key);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  late bool displayMultipleImages;
  late File activeFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.fileArray.length > 1) {
      displayMultipleImages = true;
    } else {
      displayMultipleImages = false;
    }
    multipleImageList = widget.fileArray;
    activeFile = File(multipleImageList[0].path);
  }

  // String imagePath =
  //     'https://9to5mac.com/wp-content/uploads/sites/6/2021/10/Apple_MacBook-Pro_16-inch-Screen_10182021_big_carousel.jpg.large_2x.jpg?quality=82&strip=all&w=1538';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                    onPressed: () async {
                      CroppedFile? croppedFile = await ImageCropper()
                          .cropImage(
                        sourcePath: activeFile.path,
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
                      )
                          .then((cropped) {
                        String? croppedPath = cropped!.path;
                        setState(() {
                          activeFile = File(croppedPath);
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.crop,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () async {
                      List<XFile>? multiImage =
                          await ImagePicker().pickMultiImage().then((value) {
                        value?.forEach((element) {
                          multipleImageList.add(File(element.path));
                        });
                      });
                      if (multipleImageList.isNotEmpty) {
                        setState(() {
                          displayMultipleImages = true;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.add_photo_alternate_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 50),
            Expanded(
              flex: 1,
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: double.infinity,
                  child: Image.file(
                    activeFile,
                    // height: MediaQuery.of(context).size.height,
                    // width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            if (displayMultipleImages)
              SizedBox(
                height: 80,
                child: ListView.builder(
                  itemCount: multipleImageList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          activeFile = File(multipleImageList[index].path);
                        });
                      },
                      child: Image.file(
                        multipleImageList[index],
                        key: Key('listImage$index'),
                        width: 80,
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  },
                ),
              ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 5,
              ),
              child: ActionBar(hintMessage: 'Description (optional)'),
            ),
          ],
        ),
      ),
    );
  }
}
