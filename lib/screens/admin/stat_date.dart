import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/api_service.dart';

class StatByDatePage extends StatefulWidget {
  const StatByDatePage({super.key});

  @override
  State<StatByDatePage> createState() => _StatByDatePageState();
}

class _StatByDatePageState extends State<StatByDatePage> {
  DateTime selectedDate = DateTime.now();
  int visitCount = 0;
  double averageWait = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        isLoading = true;
      });
      loadStats();
    }
  }

  void loadStats() async {
    setState(() => isLoading = true);

    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    final stats = await ApiService.getStatsByDate(dateStr);

    setState(() {
      visitCount = stats['visitCount'];
      averageWait = stats['averageWait'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

    return Scaffold(
      appBar: AppBar(title: const Text('날짜별 통계')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: pickDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(dateStr),
            ),
            const SizedBox(height: 24),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('하루 대기자 수: $visitCount명', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('평균 대기시간: ${averageWait.toStringAsFixed(1)}분', style: const TextStyle(fontSize: 18)),
                  const VisitGraphWidget(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

//그래프용
class VisitGraphWidget extends StatefulWidget {
  const VisitGraphWidget({super.key});

  @override
  State<VisitGraphWidget> createState() => _VisitGraphWidgetState();
}

class _VisitGraphWidgetState extends State<VisitGraphWidget> {
  List<Map<String, dynamic>> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadGraphData();
  }

  void loadGraphData() async {
    final result = await ApiService.getVisitStatsGraph();
    setState(() {
      data = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // maxY, interval 계산
    final maxY = data.map((e) => e['count'] as int).reduce((a, b) => a > b ? a : b).toDouble();
    final interval = (maxY / 4).ceilToDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: Text(
              '최근 일주일 대기자 수',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),
        const Divider(thickness: 1),
        const SizedBox(height: 12),

        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              maxY: maxY + interval, // 최대값 약간 더 키움
              alignment: BarChartAlignment.spaceAround,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < data.length) {
                        return Text(data[index]['date'], style: const TextStyle(fontSize: 10));
                      } else {
                        return const Text('');
                      }
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: interval,
                    getTitlesWidget: (value, meta) {
                      return Text('${value.toInt()}', style: const TextStyle(fontSize: 12));
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              barGroups: data.asMap().entries.map((entry) {
                int i = entry.key;
                var e = entry.value;
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: e['count'].toDouble(),
                      width: 14,
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 20,
                        color: Colors.grey[200],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
