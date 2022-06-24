import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_sobot_demo/common/colors.dart';
import 'package:whatsapp_sobot_demo/common/fonts.dart';
import 'package:whatsapp_sobot_demo/common/links.dart';
import 'package:whatsapp_sobot_demo/common/lists.dart';
import 'package:whatsapp_sobot_demo/common/tokens.dart';
import 'package:whatsapp_sobot_demo/widgets/chat_list_tile.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late SharedPreferences prefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAccessToken();
  }

  getAccessToken() async {
    prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    Response response = await dio.put(
      httpUrl + verifyOtp,
      data: {
        "otp": 321321,
        "mobile": "919561878080",
      },
    );
    if (response.statusCode == 200) {
      var body = response.data;
      accessToken = (body['token'])['access'];
      // print('Access Token: $token');
      prefs.setString('accessToken', accessToken.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarThemeColor,
        title: Text(
          'Gazelle and Stag',
          style: poppinsSemiBold,
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: chatList.length,
          itemBuilder: (ctx, index) {
            return Column(
              children: [
                ChatListTile(
                  username: chatList[index],
                  time: '8:26pm',
                ),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                  indent: 51,
                  endIndent: 27,
                  height: 0,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
