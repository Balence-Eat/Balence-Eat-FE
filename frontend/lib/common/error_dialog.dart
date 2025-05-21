import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String content;

  const ErrorDialog({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 연두색 테마 색상 정의
    const Color limeGreen = Color(0xFFB9F73E);

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: limeGreen, width: 2),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.green[800],
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        content,
        style: const TextStyle(
          color: Colors.black87,
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: limeGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('확인'),
        ),
      ],
    );
  }

  // showDialog를 static 메서드로 추가
  static Future<void> show(BuildContext context,
      {required String title, required String content}) {
    return showDialog(
      context: context,
      builder: (context) => ErrorDialog(title: title, content: content),
    );
  }
}
