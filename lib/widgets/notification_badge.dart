import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;
  const NotificationBadge({
    Key? key,
    required this.totalNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          '$totalNotifications',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
