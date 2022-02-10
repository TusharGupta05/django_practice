import 'package:flutter/material.dart';

String dateToString(DateTime dateTime) {
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  DateTime now = DateTime.now();
  Duration duration = now.difference(dateTime);
  if (duration.inSeconds < 60) {
    return 'just now';
  }
  if (duration.inMinutes < 60) {
    return '${duration.inMinutes}min ago';
  }
  if (duration.inHours < 24) {
    return '${duration.inHours}hr ago';
  }
  return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
}

void showLoader(BuildContext context, {String msg = 'Please wait...'}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            color: Colors.orange,
          ),
          const SizedBox(width: 20),
          Text(msg)
        ],
      ),
    ),
  );
}

void popLoader(BuildContext context) {
  Navigator.of(context).pop();
}
