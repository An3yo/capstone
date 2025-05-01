import 'package:flutter/material.dart';
import 'screens/user/user_home.dart';
import 'screens/user/enter_wait.dart';
import 'screens/admin/login.dart';
import 'screens/admin/menu.dart';
import 'screens/admin/waiting_list.dart';

import 'screens/admin/stat_date.dart';
import 'screens/admin/search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '식당 웨이팅 앱',
      initialRoute: '/',
      routes: {
        '/': (context) => const UserHomePage(),
        '/enter-wait': (context) => const EnterWaitPage(),
        '/admin-login': (context) => const AdminLoginPage(),
        '/admin-menu': (context) => const AdminMenuPage(),
        '/wait-list': (context) =>  AdminWaitingPage(),

        '/stat-date': (context) => const StatByDatePage(),
        '/search-customer': (context) => const SearchCustomerPage(),

      },
    );
  }
}