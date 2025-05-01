import 'package:flutter/material.dart';

class AdminMenuPage extends StatelessWidget {
  const AdminMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {'title': '웨이팅 목록', 'route': '/wait-list', 'icon': Icons.list},
      {'title': '고객 검색', 'route': '/search-customer', 'icon': Icons.search},
      {'title': '통계 보기', 'route': '/stat-date', 'icon': Icons.bar_chart},
      {'title': '대기 시간 설정', 'route': '/time-setting', 'icon': Icons.schedule},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('관리자 메뉴')),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(item['icon'] as IconData),
              title: Text(item['title'] as String),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, item['route'] as String);
              },
            ),
          );
        },
      ),
    );
  }
}