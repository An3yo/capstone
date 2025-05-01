import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class SearchCustomerPage extends StatefulWidget {
  const SearchCustomerPage({super.key});

  @override
  State<SearchCustomerPage> createState() => _SearchCustomerPageState();
}

class _SearchCustomerPageState extends State<SearchCustomerPage> {
  final TextEditingController _controller = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> results = [];
  bool isLoading = false;

  String get formattedDate =>
      DateFormat('yyyy-MM-dd').format(selectedDate);

  void search() async {
    final phone = _controller.text.trim();
    final dateStr = formattedDate;

    setState(() => isLoading = true);

    final all = await ApiService.getAllWaitings();
    final filtered = all.where((e) {
      final matchPhone = phone.isEmpty || e['phone'] == phone;
      final matchDate = e['date'] == dateStr;
      return matchPhone && matchDate;
    }).toList();

    setState(() {
      results = filtered;
      isLoading = false;
    });
  }

  void pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('고객 검색')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 날짜 선택 버튼
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: pickDate,
                icon: const Icon(Icons.calendar_today),
                label: Text(formattedDate),
              ),
            ),
            const SizedBox(height: 12),

            // 🔍 전화번호 검색창 + 검색 버튼
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: '전화번호',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => search(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: search,
                  child: const Text('검색'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            if (isLoading)
              const CircularProgressIndicator()
            else if (results.isEmpty)
              const Text('검색 결과가 없습니다')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final item = results[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('${item['phone']} (${item['people']}명)'),
                            subtitle: Text(item['status'] == 'entered'
                                ? '입장 시간: ${item['enteredTime']}'
                                : '등록 시간: ${item['startTime']} / 대기시간: ${item['wait']}분'),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                ),
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
                                      Text('날짜: ${item['date']}'),
                                      if (item['status'] == 'entered')
                                        Text('입장 시각: ${item['enteredTime']}')
                                      else
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('등록 시각: ${item['startTime']}'),
                                            Text('대기 시간: ${item['wait']}분'),
                                          ],
                                        ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('닫기'),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          if (item['status'] == 'waiting')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.campaign),
                                  tooltip: '호출',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${item['id']}번 호출')),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.check_circle),
                                  tooltip: '입장',
                                  onPressed: () async {
                                    await ApiService.enterWaiting(item['id']);
                                    search();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${item['id']}번 입장 처리됨')),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.cancel),
                                  tooltip: '취소',
                                  onPressed: () async {
                                    await ApiService.cancelWaiting(item['id']);
                                    search();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${item['id']}번 대기 취소됨')),
                                    );
                                  },
                                ),
                              ],
                            )
                          else if (item['status'] == 'entered')
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(Icons.cancel),
                                tooltip: '입장 취소',
                                onPressed: () async {
                                  await ApiService.cancelWaiting(item['id']);
                                  search();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${item['id']}번 입장 취소됨')),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
