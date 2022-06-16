import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final String msg;
  // final String time = '';
  const MessageWidget({
    Key? key,
    required this.msg,
    // this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 80,
          // minWidth: 100,
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              8.0,
            ),
          ),
          elevation: 1,
          color: const Color(0xFFE0F6CA),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Text(
                  msg,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                // bottom: 4,
                // right: 10,
                child: SizedBox(
                  height: 30,
                  child: Column(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 0,
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: Row(
                          children: [
                            Text(
                              '1:08pm',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
