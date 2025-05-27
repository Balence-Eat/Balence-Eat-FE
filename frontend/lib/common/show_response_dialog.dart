import 'package:flutter/material.dart';

void showResponseDialog(BuildContext context, int statusCode, String message) {
  String title;
  String content;

  switch (statusCode) {
    case 200:
    case 201:
      title = '성공';
      content = message.isNotEmpty ? message : '요청이 성공적으로 처리되었습니다.';
      break;
    case 400:
      title = '잘못된 요청';
      content = message.isNotEmpty ? message : '요청 형식이 잘못되었습니다.';
      break;
    case 401:
      title = '인증 실패';
      content = message.isNotEmpty ? message : '아이디 또는 비밀번호가 올바르지 않습니다.';
      break;
    case 409:
      title = '중복 오류';
      content = message.isNotEmpty ? message : '이미 존재하는 사용자입니다.';
      break;
    case 500:
      title = '서버 오류';
      content = message.isNotEmpty ? message : '서버에서 오류가 발생했습니다.';
      break;
    default:
      title = '알 수 없는 오류';
      content = message.isNotEmpty ? message : '예기치 못한 오류가 발생했습니다.';
  }

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      content: Text(
        content,
        style: TextStyle(fontSize: 15),
      ),
      actions: [
        TextButton(
          child: const Text('확인'),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
