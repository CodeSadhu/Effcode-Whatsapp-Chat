import 'dart:convert';
import 'dart:io';
// import 'dart:html';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'package:whatsapp_sobot_demo/models/request_message.dart';
import 'package:whatsapp_sobot_demo/screens/chat_list.dart';
import 'package:whatsapp_sobot_demo/screens/chat_screen.dart';
import 'package:whatsapp_sobot_demo/widgets/image_preview.dart';
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
      // home: const ChatScreen(),
      home: ChatListScreen(),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
    );
  }
}
