import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp_sobot_demo/common/colors.dart';
import 'package:whatsapp_sobot_demo/common/fonts.dart';

class ChatListTile extends StatelessWidget {
  final String username;
  final List<String>? labels;
  final String time;
  const ChatListTile({
    Key? key,
    required this.username,
    required this.time,
    this.labels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isUnread = false;
    // return TileWidget();
    return Container(
      height: 130,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 12,
      ),
      width: MediaQuery.of(context).size.width,
      // color: appBarThemeColor,
      child: Stack(
        // fit: StackFit.expand,
        children: [
          Positioned(
            top: 15,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: listTileColor,
              child: Text(
                username.characters.first.toUpperCase(),
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 60,
            child: Text(
              username,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 20),
            ),
          ),
          Positioned(
            top: 5,
            left: 120,
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 200,
              ),
              child: Transform(
                transform: Matrix4.identity()..scale(0.5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Chip(
                      padding: EdgeInsets.all(0),
                      labelPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 15,
                      ),
                      label: Text(
                        'New',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: chipColor1,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Chip(
                      padding: EdgeInsets.all(0),
                      labelPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 5,
                      ),
                      label: Text(
                        'Pending Payment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: chipColor2,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 60,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 190),
              child: Text(
                'Would you like to see more products?',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 0,
            child: Text(
              time,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color:
                    isUnread ? unreadMessageIndicatorColor : Colors.grey[700],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 40,
            child: Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: unreadMessageIndicatorColor,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 60,
            child: Transform(
              transform: Matrix4.identity()..scale(0.8),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  maximumSize: const Size(120, 50),
                  primary: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.blue[300],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Assign To',
                      style: TextStyle(fontSize: 12, color: Colors.blue[300]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class TileWidget extends StatelessWidget {
//   const TileWidget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: CircleAvatar(
//         radius: 23,
//         backgroundColor: listTileColor,
//         child: Text(
//           'N',
//           style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//         ),
//       ),
//       title: Row(
//         children: [
//           Text(
//             'Nikhil',
//             style:
//                 GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 20),
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           Positioned(
//             top: 10,
//             child: Row(
//               children: [
//                 Transform(
//                   transform: Matrix4.identity()..scale(0.6),
//                   child: const Chip(
//                     padding: EdgeInsets.all(0),
//                     labelPadding: EdgeInsets.symmetric(
//                       vertical: 0,
//                       horizontal: 15,
//                     ),
//                     label: Text(
//                       'New',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                       ),
//                     ),
//                     backgroundColor: chipColor1,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       subtitle: Text(
//         'Would you like to see more products?',
//         style: GoogleFonts.poppins(fontWeight: FontWeight.normal),
//         overflow: TextOverflow.ellipsis,
//       ),
//       contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//       trailing: SizedBox(
//         width: 50,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 '8:29pm',
//                 style: GoogleFonts.poppins(fontSize: 12),
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: Container(
//                 height: 20,
//                 width: 20,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   color: unreadMessageIndicatorColor,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
