import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class AdminWaitingPage extends StatefulWidget {
  const AdminWaitingPage({super.key});

  @override
  State<AdminWaitingPage> createState() => _AdminWaitingPageState();
}

class _AdminWaitingPageState extends State<AdminWaitingPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> waitings = [];
  List<Map<String, dynamic>> entered = [];
  bool isLoading = true;
  Timer? refreshTimer;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadData();

    refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      loadData();
    });
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  //오늘자 데이터만 가져옴
  void loadData() async {
    final all = await ApiService.getAllWaitings();
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    setState(() {
      waitings = all.where((e) =>
      e['status'] == 'waiting' && e['date'] == todayStr
      ).toList();

      entered = all.where((e) =>
      e['status'] == 'entered' && e['date'] == todayStr
      ).toList();

      isLoading = false;
    });
  }


  void showDetailModal(BuildContext context, Map<String, dynamic> item, {bool isEntered = false}) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('대기번호: ${item['id']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('전화번호: ${item['phone']}'),
            Text('인원 수: ${item['people']}명'),
            if (isEntered)
              Text('입장 시각: ${item['enteredTime']}')
            else
              Text('등록 시각: ${item['startTime']}\n대기 시간: ${item['wait']}분'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('닫기'),
            )
          ],
        ),
      ),
    );
  }

  //대기목록
  Widget buildWaitingList() {
    return ListView.builder(
      itemCount: waitings.length,
      itemBuilder: (context, index) {
        final item = waitings[index];
        return GestureDetector(
          onTap: () => showDetailModal(context, item),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(
                      '${item['id']}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item['phone']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        Text('${item['people']}명', style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.campaign),
                        tooltip: '호출',
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item['id']}번 호출'))),
                      ),
                      IconButton(
                        icon: const Icon(Icons.check_circle),
                        tooltip: '입장',
                        onPressed: () async {
                          await ApiService.enterWaiting(item['id']);
                          loadData();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item['id']}번 입장 처리됨')));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        tooltip: '취소',
                        onPressed: () async {
                          await ApiService.cancelWaiting(item['id']);
                          loadData();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item['id']}번 대기 취소됨')));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //입장완료목록
  Widget buildEnteredList() {
    return ListView.builder(
      itemCount: entered.length,
      itemBuilder: (context, index) {
        final item = entered[index];
        return GestureDetector(
          onTap: () => showDetailModal(context, item, isEntered: true),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(
                      '${item['id']}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item['phone']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        Text('${item['people']}명', style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    tooltip: '입장 취소',
                    onPressed: () async {
                      await ApiService.cancelWaiting(item['id']);
                      loadData();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item['id']}번 입장 취소됨')));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('웨이팅 목록'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '대기 목록'),
            Tab(text: '입장 완료'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          buildWaitingList(),
          buildEnteredList(),
        ],
      ),
    );
  }
}
