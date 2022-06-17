import 'dart:convert';
// import 'dart:html';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'package:whatsapp_sobot_demo/models/request_message.dart';
import 'package:whatsapp_sobot_demo/widgets/message_widget.dart';
import 'package:whatsapp_sobot_demo/widgets/reply_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const ChatScreen(),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const conversationID = 79;
  static const httpUrl =
      'http://sobot-env.eba-ceyv8psy.ap-south-1.elasticbeanstalk.com';
  static const authToken =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjU1MzY4NjQyLCJpYXQiOjE2NTUyODIyNDIsImp0aSI6IjA1YWM3NjNhOGIzYzRlMDE5N2E4NDdhYWI5NTRhZDU3IiwidXNlcl9pZCI6M30.UcePQ30CCA_UyZgL1Mbk37eef8kHHzgaIdjjKpky6eo';
  static const String baseUrl =
      'ws://sobot-env.eba-ceyv8psy.ap-south-1.elasticbeanstalk.com/ws/chat/hello/?token=$authToken';
  final WebSocketChannel socket = IOWebSocketChannel.connect(
    baseUrl,
  );
  final FocusNode focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  final List<dynamic> replyMsgs = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchMessages();
    socket.stream.listen((data) {
      RequestMessageModel reqModel =
          RequestMessageModel.fromJson(jsonDecode(data));
      // print(reqModel);
      setState(() {
        replyMsgs.add(reqModel.msg);
        _scrollToBottom();
      });
    });
  }

  uploadFile() async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();
    if (fileResult != null) {
      PlatformFile file = fileResult.files.first;
      // print("File selected: $file");
      Dio dio = Dio();
      try {
        FormData formData = FormData.fromMap({
          "image": await MultipartFile.fromFile(
            file.path!,
            filename: file.name,
            contentType: MediaType('image', 'jpg'),
          ),
          'type': 'image/jpg'
        });
        Response resp = await dio.post(
          'https://sobot-assets.s3.amazonaws.com',
          data: formData,
          options: Options(headers: {
            'key': '/images/first_1.jpg',
            'x-amz-algorithm': 'AWS4-HMAC-SHA256',
            'x-amz-credential':
                'AKIAR6WSBXNMI6ZSOHXT/20220617/us-east-1/s3/aws4_request',
            'x-amz-date': '20220617T111757Z',
            'policy':
                'eyJleHBpcmF0aW9uIjogIjIwMjItMDYtMTdUMTE6MjI6NTdaIiwgImNvbmRpdGlvbnMiOiBbeyJidWNrZXQiOiAic29ib3QtYXNzZXRzIn0sIHsia2V5IjogIi9pbWFnZXMvZmlyc3RfMS5qcGcifSwgeyJ4LWFtei1hbGdvcml0aG0iOiAiQVdTNC1ITUFDLVNIQTI1NiJ9LCB7IngtYW16LWNyZWRlbnRpYWwiOiAiQUtJQVI2V1NCWE5NSTZaU09IWFQvMjAyMjA2MTcvdXMtZWFzdC0xL3MzL2F3czRfcmVxdWVzdCJ9LCB7IngtYW16LWRhdGUiOiAiMjAyMjA2MTdUMTExNzU3WiJ9XX0=',
            'x-amz-signature':
                '0774a107482975c68be14308dfe76e053870eb2e52a4e0a23845fd347ce0a5e1'
          }),
        );
      } catch (e) {
        print(e);
      }
    }
  }

  Future<http.Response> fetchMessages() async {
    var response = await http.get(
        Uri.parse(httpUrl + '/conversations/$conversationID/message/'),
        headers: {
          'Authorization': 'JWT ' + authToken,
        });
    // print(response.body);
    dynamic respData = jsonDecode(response.body);
    // print('Response Data: ${respData['data'][0]}');
    dynamic responseObject = respData['data'];
    for (dynamic item in responseObject) {
      // print(item['message']);
      // RequestMessageModel reqModel =
      //     RequestMessageModel.fromJson(jsonDecode(item));
      replyMsgs.add(item['message']);
    }
    setState(() {});
    // print(httpUrl);
    return response;
  }

  Future<http.Response> sendMessage(String msg) async {
    dynamic body = {
      'raw': {
        'msessage': msg,
        'gs_msg_type': 'text',
        'conversations_id': 75,
      },
    };
    var response = await http.post(
        Uri.parse(httpUrl + '/conversations/message/'),
        body: jsonEncode(body),
        headers: {
          'Authorization': 'JWT ' + authToken,
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
          buildBottomSection(),
        ],
      ),
    );
  }

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  ListView buildMessages() {
    // List<Widget> widgetList = [];

    // for (String reply in replyMsgs) {
    //   // print(item);
    //   // jsonDecode(item);
    //   // print('decoded ${item.runtimeType}');
    //   widgetList.add(
    //     ReplyWidget(
    //       msg: reply,
    //     ),
    //   );
    //   widgetList.add(
    //     MessageWidget(
    //       msg: reply,
    //     ),
    //   );
    // }

    return ListView.builder(
      shrinkWrap: true,
      // reverse: true,
      scrollDirection: Axis.vertical,
      itemCount: replyMsgs.length,
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 50),
      itemBuilder: (context, index) {
        _scrollToBottom();
        return index.isOdd
            ? MessageWidget(msg: replyMsgs[index])
            : ReplyWidget(msg: replyMsgs[index]);
      },
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
                          onPressed: () async {
                            uploadFile();
                          },
                          icon: const Icon(Icons.attach_file),
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
      title: const Text(
        'Test User',
        textAlign: TextAlign.left,
        style: TextStyle(
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
            onPressed: () {},
          ),
          const CircleAvatar(
            child: Text(
              'T',
              style: TextStyle(
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
