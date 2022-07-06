import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_sobot_demo/common/colors.dart';
import 'package:whatsapp_sobot_demo/common/fonts.dart';
import 'package:whatsapp_sobot_demo/common/links.dart';
import 'package:whatsapp_sobot_demo/common/lists.dart';
import 'package:whatsapp_sobot_demo/common/tokens.dart';
import 'package:whatsapp_sobot_demo/models/push_notification.dart';
import 'package:whatsapp_sobot_demo/screens/chat_screen.dart';
import 'package:whatsapp_sobot_demo/widgets/chat_list_tile.dart';
import 'package:whatsapp_sobot_demo/widgets/notification_badge.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late SharedPreferences prefs;
  PushNotification? notificationInfo;
  late int _totalNotifications;
  late final FirebaseMessaging messaging;
  late List chatList = [];
  Dio dio = Dio();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTokenFCM();
    registerNotification();
    //
    getAccessToken();
    // THIS API CALL ABOVE IS VITAL FOR EVERY OTHER API CALL TO BE MADE THROUGHOUT THE APP FURTHER
    //
    _totalNotifications = 0;
  }

  getConversations() async {
    Response response = await dio.get(
      httpUrl + getAllConversations,
      options: Options(headers: {
        'Authorization': 'JWT $accessToken',
      }),
    );
    if (response.statusCode == 200) {
      var body = response.data['data'];
      setState(() {
        chatList = body;
      });
      chatList.forEach((element) {
        // print((element['customer'])['name']);
        print(element["customer"]);
      });
      // var item = body[0];
      // var name = (item['contact'])['name'];
      // print('Get conversations body: $body');
    }
  }

  Future<void> getTokenFCM() async {
    await FirebaseMessaging.instance.getToken().then(
      (token) {
        print('FCM Token: ${token}');
      },
    );
  }

  displayNotification() {
    print(
        'Display Notification entered, notificationInfo status: ${notificationInfo!.title}');
    if (notificationInfo != null) {
      showSimpleNotification(
        Text(
          notificationInfo!.title!,
        ),
        leading: NotificationBadge(totalNotifications: _totalNotifications),
        subtitle: Text(
          notificationInfo!.body!,
          style: TextStyle(color: Colors.white),
        ),
        background: Colors.purple.shade700,
        duration: Duration(seconds: 2),
      );
    }
  }

  registerNotification() async {
    await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;

    // UNCOMMENT BELOW CODE FOR iOS

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // setState(() {
      //   displayNotification();
      // });
      print('Granted permission');
    } else {
      print('Permission not granted');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      PushNotification notification = PushNotification(
        body: remoteMessage.notification?.body,
        title: remoteMessage.notification?.title,
      );
      setState(() {
        notificationInfo = notification;
        displayNotification();
        _totalNotifications += 1;
      });
    });
  }

  getAccessToken() async {
    prefs = await SharedPreferences.getInstance();
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
      print('Access Token: $accessToken');
      prefs.setString('accessToken', accessToken.toString());
      getConversations();
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
        // child: Column(
        //   children: [
        //     const SizedBox(
        //       height: 10,
        //     ),
        //     // Align(alignment: Align,)
        //   ],
        // ),
        child: ListView.builder(
          itemCount: chatList.length,
          itemBuilder: (ctx, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => ChatScreen(
                      chatUserData: chatList[index],
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  ChatListTile(
                    key: Key('UserTile #${index.toString()}'),
                    username:
                        ((chatList[index])['customer'])['name'].toString(),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
