import 'package:flutter/material.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int waitingCount = 8; // 나중에 API에서 받아올 값
  int estimatedTime = 10;

  @override
  void initState() {
    super.initState();
    // 나중에 여기서 API 호출로 대체 가능
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('대기ZERO'),
        leading: IconButton(icon: const Icon(Icons.admin_panel_settings),
        onPressed: () {
          Navigator.pushNamed(context, '/admin-login');
        },
      ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('현재 대기 인원', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('$waitingCount 명',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const Text('예상 대기 시간', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('$estimatedTime 분',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/enter-wait');
              },
              child: const Text('대기 등록하러 가기'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}