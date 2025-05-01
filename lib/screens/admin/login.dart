import 'package:flutter/material.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController passwordController = TextEditingController();
  final String correctPassword = '1234'; // 임시 비번, 나중에 서버 연결 가능

  void _tryLogin() {
    if (passwordController.text == correctPassword) {
      Navigator.pushReplacementNamed(context, '/admin-menu');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('오류'),
          content: const Text('비밀번호가 틀렸습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('관리자 로그인')),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('관리자 비밀번호 입력'),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '비밀번호',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _tryLogin,
              child: const Text('로그인'),
            )
          ],
        ),
      ),
    );
  }
}