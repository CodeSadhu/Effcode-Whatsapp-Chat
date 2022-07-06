import 'dart:convert';
import 'dart:io';
// import 'dart:html';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'package:whatsapp_sobot_demo/common/links.dart';
import 'package:whatsapp_sobot_demo/common/tokens.dart';
import 'package:whatsapp_sobot_demo/models/request_message.dart';
import 'package:whatsapp_sobot_demo/widgets/image_preview.dart';
import 'package:whatsapp_sobot_demo/widgets/message_widget.dart';
import 'package:whatsapp_sobot_demo/widgets/reply_widget.dart';

class ChatScreen extends StatefulWidget {
  final dynamic chatUserData;
  const ChatScreen({
    Key? key,
    required this.chatUserData,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  var conversationID;
  // static const accessToken =
  //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjU1MzY4NjQyLCJpYXQiOjE2NTUyODIyNDIsImp0aSI6IjA1YWM3NjNhOGIzYzRlMDE5N2E4NDdhYWI5NTRhZDU3IiwidXNlcl9pZCI6M30.UcePQ30CCA_UyZgL1Mbk37eef8kHHzgaIdjjKpky6eo';
  // final String baseUrl =
  //     'ws://sobot-env.eba-ceyv8psy.ap-south-1.elasticbeanstalk.com/ws/chat/hello/?token=$accessToken';
  final WebSocketChannel socket = IOWebSocketChannel.connect(
    'ws://sobot-env.eba-ceyv8psy.ap-south-1.elasticbeanstalk.com/ws/chat/hello/?token=$accessToken',
  );
  final FocusNode focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> animation;
  final List<dynamic> replyMsgs = [];
  final ScrollController _scrollController = ScrollController();
  bool _modalVisible = false;

  @override
  void initState() {
    super.initState();
    //
    setToken();
    // RETRIEVE ACCESS TOKEN IMMEDIATELY AS SOON AS THE USER COMES INTO THE CHAT SCREEN
    //
    conversationID = widget.chatUserData['id'];
    print('Conversation id: $conversationID');
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    fetchMessages();
  }

  setToken() async {
    await SharedPreferences.getInstance().then(
      (prefs) {
        prefs.getString('accessToken');
      },
    ).then((token) {
      accessToken = token.toString();
      socket.stream.listen((data) {
        RequestMessageModel reqModel =
            RequestMessageModel.fromJson(jsonDecode(data));
        // print(reqModel);
        setState(() {
          replyMsgs.add(reqModel.msg);
          _scrollToBottom();
        });
      });
    });
    // print('accessToken: $accessToken');
  }

  uploadFile(fileType) async {
    if (fileType != FileType.image) {
      FilePickerResult? fileResult =
          await FilePicker.platform.pickFiles(type: fileType);
      if (fileResult != null) {
        PlatformFile file = fileResult.files.first;

        // print("File selected: $file");
        // Dio dio = Dio();
        // try {
        // FormData formData = FormData.fromMap({
        //   "image": await MultipartFile.fromFile(
        //     file.path!,
        //     filename: file.name,
        //     contentType: MediaType('image', 'jpg'),
        //   ),
        //   'type': 'image/jpg'
        // });
        // FormData formData = FormData.fromMap({
        //   // 'file': await MultipartFile.fromFile(file.path!, filename: file.name),
        //   'files': [
        //     await MultipartFile.fromFile(file.path!,
        //         filename: file.name, contentType: MediaType('image', 'jpg')),
        //   ],
        //   'fields': {
        //     'key': '/images/first_1.jpg',
        //     'x-amz-algorithm': 'AWS4-HMAC-SHA256',
        //     'x-amz-credential':
        //         'AKIAR6WSBXNMI6ZSOHXT/20220618/us-east-1/s3/aws4_request',
        //     'x-amz-date': '20220618T091445Z',
        //     'policy':
        //         'eyJleHBpcmF0aW9uIjogIjIwMjItMDYtMThUMTA6MDQ6NDVaIiwgImNvbmRpdGlvbnMiOiBbeyJidWNrZXQiOiAic29ib3QtYXNzZXRzIn0sIHsia2V5IjogIi9pbWFnZXMvZmlyc3RfMS5qcGcifSwgeyJ4LWFtei1hbGdvcml0aG0iOiAiQVdTNC1ITUFDLVNIQTI1NiJ9LCB7IngtYW16LWNyZWRlbnRpYWwiOiAiQUtJQVI2V1NCWE5NSTZaU09IWFQvMjAyMjA2MTgvdXMtZWFzdC0xL3MzL2F3czRfcmVxdWVzdCJ9LCB7IngtYW16LWRhdGUiOiAiMjAyMjA2MThUMDkxNDQ1WiJ9XX0=',
        //     'x-amz-signature':
        //         '0cf09d5c1de94d902b4400efd77a9b385397de4de0104bf8a6fc16e852d14d9a'
        //   }
        // });
        // var response = await dio.post(
        //   'https://sobot-assets.s3.amazonaws.com/',
        //   data: formData,
        //   // options: Options(
        //   //   headers: {
        //   //     'fields': {
        //   //       'key': '/images/first_1.jpg',
        //   //       'x-amz-algorithm': 'AWS4-HMAC-SHA256',
        //   //       'x-amz-credential':
        //   //           'AKIAR6WSBXNMI6ZSOHXT/20220618/us-east-1/s3/aws4_request',
        //   //       'x-amz-date': '20220618T091445Z',
        //   //       'policy':
        //   //           'eyJleHBpcmF0aW9uIjogIjIwMjItMDYtMThUMTA6MDQ6NDVaIiwgImNvbmRpdGlvbnMiOiBbeyJidWNrZXQiOiAic29ib3QtYXNzZXRzIn0sIHsia2V5IjogIi9pbWFnZXMvZmlyc3RfMS5qcGcifSwgeyJ4LWFtei1hbGdvcml0aG0iOiAiQVdTNC1ITUFDLVNIQTI1NiJ9LCB7IngtYW16LWNyZWRlbnRpYWwiOiAiQUtJQVI2V1NCWE5NSTZaU09IWFQvMjAyMjA2MTgvdXMtZWFzdC0xL3MzL2F3czRfcmVxdWVzdCJ9LCB7IngtYW16LWRhdGUiOiAiMjAyMjA2MThUMDkxNDQ1WiJ9XX0=',
        //   //       'x-amz-signature':
        //   //           '0cf09d5c1de94d902b4400efd77a9b385397de4de0104bf8a6fc16e852d14d9a'
        //   //     }
        //   //   },
        //   // ),
        // );
        // print('Dio response: $response');

        // var url = Uri.parse('https://sobot-assets.s3.amazonaws.com/');
        // var request = http.MultipartRequest("POST", url);
        // request.fields['key'] = '/images/first_1.jpg';
        // request.fields['x-amz-algorithm'] = 'AWS4-HMAC-SHA256';
        // request.fields['x-amz-credential'] = 'AKIAR6WSBXNMI6ZSOHXT/20220618/us-east-1/s3/aws4_request';
        // request.files.add(http.MultipartFile(field, stream, length));
        // request.send().then((response) {
        //   if (response.statusCode == 200) print("Uploaded!");
        // });

        // Response resp = await dio.post('https://sobot-assets.s3.amazonaws.com/',
        //     data: formData,
        //     options: Options(headers: {
        //       'conditions': [
        //         {'key': '/images/first_1.jpg'},
        //         {'x-amz-algorithm': 'AWS4-HMAC-SHA256'},
        //         {
        //           'x-amz-credential':
        //               'AKIAR6WSBXNMI6ZSOHXT/20220618/us-east-1/s3/aws4_request'
        //         },
        //         {'x-amz-date': '20220618T091445Z'},
        //         {
        //           'policy':
        //               'eyJleHBpcmF0aW9uIjogIjIwMjItMDYtMThUMTA6MDQ6NDVaIiwgImNvbmRpdGlvbnMiOiBbeyJidWNrZXQiOiAic29ib3QtYXNzZXRzIn0sIHsia2V5IjogIi9pbWFnZXMvZmlyc3RfMS5qcGcifSwgeyJ4LWFtei1hbGdvcml0aG0iOiAiQVdTNC1ITUFDLVNIQTI1NiJ9LCB7IngtYW16LWNyZWRlbnRpYWwiOiAiQUtJQVI2V1NCWE5NSTZaU09IWFQvMjAyMjA2MTgvdXMtZWFzdC0xL3MzL2F3czRfcmVxdWVzdCJ9LCB7IngtYW16LWRhdGUiOiAiMjAyMjA2MThUMDkxNDQ1WiJ9XX0='
        //         },
        //         {
        //           'x-amz-signature':
        //               '0cf09d5c1de94d902b4400efd77a9b385397de4de0104bf8a6fc16e852d14d9a'
        //         }
        //       ]
        //     })
        //     // options: Options(headers: {
        //     //   'key': '/images/first_1.jpg',
        //     //   'x-amz-algorithm': 'AWS4-HMAC-SHA256',
        //     //   'x-amz-credential':
        //     //       'AKIAR6WSBXNMI6ZSOHXT/20220617/us-east-1/s3/aws4_request',
        //     //   'x-amz-date': '20220617T111757Z',
        //     //   'policy':
        //     //       'eyJleHBpcmF0aW9uIjogIjIwMjItMDYtMTdUMTE6MjI6NTdaIiwgImNvbmRpdGlvbnMiOiBbeyJidWNrZXQiOiAic29ib3QtYXNzZXRzIn0sIHsia2V5IjogIi9pbWFnZXMvZmlyc3RfMS5qcGcifSwgeyJ4LWFtei1hbGdvcml0aG0iOiAiQVdTNC1ITUFDLVNIQTI1NiJ9LCB7IngtYW16LWNyZWRlbnRpYWwiOiAiQUtJQVI2V1NCWE5NSTZaU09IWFQvMjAyMjA2MTcvdXMtZWFzdC0xL3MzL2F3czRfcmVxdWVzdCJ9LCB7IngtYW16LWRhdGUiOiAiMjAyMjA2MTdUMTExNzU3WiJ9XX0=',
        //     //   'x-amz-signature':
        //     //       '0774a107482975c68be14308dfe76e053870eb2e52a4e0a23845fd347ce0a5e1'
        //     // }),
        //     );
        // } on DioError catch (e) {
        //   print('Dio error: ${e.error}');
        // }
      }
    } else {
      final imageFile = await ImagePicker().pickMultiImage().then((xfileArray) {
        previewImage(xfileArray!);
      });
      // if (imageFile != null) {
      //   File file = File(imageFile.path);
      //   previewImage(file);
      // }
      // previewImage(file);
    }
  }

  Future<http.Response> fetchMessages() async {
    var response = await http.get(
        Uri.parse(httpUrl + '/conversations/$conversationID/message/'),
        headers: {
          'Authorization': 'JWT ' + accessToken,
        });
    // print(response.body);
    dynamic respData = jsonDecode(response.body);
    // print('Response Data: ${respData['data'][0]}');
    dynamic responseObject = respData['data'];
    for (dynamic item in responseObject) {
      print(item['message']);
      // RequestMessageModel reqModel =
      //     RequestMessageModel.fromJson(jsonDecode(item));
      replyMsgs.add(item['message']);
    }
    setState(() {});
    // print(httpUrl);.0
    return response;
  }

  Future<http.Response> sendMessage(String msg) async {
    dynamic body = {
      'raw': {
        'msessage': msg,
        'gs_msg_type': 'text',
        'conversations_id': conversationID,
      },
    };
    var response = await http.post(
        Uri.parse(httpUrl + '/conversations/message/'),
        body: jsonEncode(body),
        headers: {
          'Authorization': 'JWT $accessToken',
        });
    // print('Send resp: ${response.toString()}');
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: const Color(0xFFECE5DD),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: buildMessages(),
          ),
          // if (_modalVisible)
          CircularRevealAnimation(
            animation: animation,
            centerAlignment: Alignment.bottomCenter,
            // centerOffset: Offset(130, 100),
            maxRadius: 500,
            minRadius: 0,
            child: ModalFilePicker(),
          ),
          buildBottomSection(),
        ],
      ),
    );
  }

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  Widget ModalFilePicker() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10,
        ),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.purple[400],
                child: const Icon(
                  Icons.image,
                ),
                onPressed: () {
                  uploadFile(FileType.image);
                },
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                'Image',
                style: TextStyle(color: Colors.grey[800], fontSize: 12),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.purple[900],
                child: const Icon(Icons.play_circle),
                onPressed: () {
                  uploadFile(FileType.video);
                },
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                'Video',
                style: TextStyle(color: Colors.grey[800], fontSize: 12),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.green[700],
                child: const Icon(
                  Icons.file_copy,
                ),
                onPressed: () {
                  uploadFile(FileType.custom);
                },
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                'Document',
                style: TextStyle(color: Colors.grey[800], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMessages() {
    return GestureDetector(
      onTap: () {
        // if (_animationController.status == AnimationStatus.forward)
        _animationController.reverse();
      },
      child: ListView.builder(
        shrinkWrap: true,
        // reverse: true,
        scrollDirection: Axis.vertical,
        itemCount: replyMsgs.length,
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 50),
        itemBuilder: (context, index) {
          _scrollToBottom();
          return index.isEven
              ? MessageWidget(msg: replyMsgs[index])
              : ReplyWidget(msg: replyMsgs[index]);
        },
      ),
    );
  }

  Align buildBottomSection() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 70,
        // width: 50,
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    30.0,
                  ),
                ),
                child: TextFormField(
                  controller: _textController,
                  maxLines: 5,
                  minLines: 1,
                  focusNode: focusNode,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Message",
                    hintMaxLines: 1,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.note_add,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            // displayFilePicker()
                            // showFilePicker();
                            setState(() {
                              _modalVisible = !_modalVisible;
                            });
                            if (_animationController.status ==
                                    AnimationStatus.forward ||
                                _animationController.status ==
                                    AnimationStatus.completed)
                              _animationController.reverse();
                            else
                              _animationController.forward();
                          },
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    30.0,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Color(0xFF54656F),
                  ),
                  onPressed: () {
                    if (_textController.text != '') {
                      sendMessage(_textController.text);
                      _textController.clear();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  previewImage(List<XFile> xfileArray) {
    List<File> convertedFileArray = [];
    xfileArray.forEach((element) {
      convertedFileArray.add(File(element.path));
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => ImagePreview(fileArray: convertedFileArray),
      ),
    );
  }

  Future<dynamic> showFilePicker() {
    return showModalBottomSheet(
        barrierColor: Colors.transparent,
        backgroundColor: Colors.white,
        enableDrag: true,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        constraints: const BoxConstraints(
          maxHeight: 300,
          maxWidth: double.infinity,
        ),
        context: context,
        builder: (ctx) {
          return Container(
            margin: const EdgeInsets.only(bottom: 5.0),
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.purple[400],
                      child: const Icon(
                        Icons.image,
                      ),
                      onPressed: () {
                        uploadFile(FileType.image);
                      },
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Text(
                      'Image',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.purple[900],
                      child: const Icon(Icons.play_circle),
                      onPressed: () {
                        uploadFile(FileType.video);
                      },
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Text(
                      'Video',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.green[700],
                      child: const Icon(
                        Icons.file_copy,
                      ),
                      onPressed: () {
                        uploadFile(FileType.custom);
                      },
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Text(
                      'Document',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.teal[800],
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.more_vert,
          ),
        ),
      ],
      leadingWidth: double.infinity,
      titleSpacing: 0,
      title: Text(
        (widget.chatUserData['customer'])['name'],
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      leading: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CircleAvatar(
            child: Text(
              (widget.chatUserData['customer'])['name']
                  .toString()
                  .characters
                  .first
                  .toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Color(0xFFC5E1DA),
          ),
        ],
      ),
    );
  }
}
