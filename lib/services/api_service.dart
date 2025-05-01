import 'dart:convert';
import 'package:http/http.dart' as http;

//임시데이터
class ApiService {
  static const baseUrl = 'http://localhost:3000'; // 실제 서버 주소로 교체 예정

  /// 모든 웨이팅 목록 불러오기 (가짜 데이터)
  static Future<List<Map<String, dynamic>>> getAllWaitings() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      {'id': 1, 'phone': '01012340001', 'people': 2, 'startTime': '17:10', 'wait': 10, 'status': 'entered','enteredTime': '17:20', 'date': '2025-04-25'},
      {'id': 2, 'phone': '01012340002', 'people': 3, 'startTime': '17:20', 'wait': 12, 'status': 'entered', 'enteredTime': '17:22', 'date': '2025-04-25'},
      {'id': 3, 'phone': '01012340003', 'people': 1, 'startTime': '17:25', 'wait': 5, 'status': 'waiting', 'date': '2025-04-25'},
      {'id': 4, 'phone': '01012340004', 'people': 4, 'startTime': '17:30', 'wait': 9, 'status': 'waiting', 'date': '2025-04-25'},
      {'id': 5, 'phone': '01012340005', 'people': 2, 'startTime': '17:35', 'wait': 3, 'status': 'waiting', 'date': '2025-04-25'},
      {'id': 6, 'phone': '01012340006', 'people': 3, 'startTime': '17:40', 'wait': 8, 'status': 'waiting', 'date': '2025-04-25'},
      {'id': 7, 'phone': '01012340007', 'people': 2, 'startTime': '17:42', 'wait': 2, 'status': 'waiting', 'date': '2025-04-25'},
      {'id': 8, 'phone': '01012340008', 'people': 1, 'startTime': '17:43', 'wait': 1, 'status': 'waiting', 'date': '2025-04-25'},
      {'id': 9, 'phone': '01012340009', 'people': 4, 'startTime': '17:44', 'wait': 5, 'status': 'waiting',  'date': '2025-04-25'},
      {'id': 10, 'phone': '01012340010', 'people': 2, 'startTime': '17:45', 'wait': 0, 'status': 'waiting', 'date': '2025-04-25'},
      //어제 날짜
      {'id': 1, 'phone': '01011110001', 'people': 2, 'startTime': '17:10', 'wait': 10, 'status': 'waiting', 'date': '2025-04-24'},
      {'id': 2, 'phone': '01011110002', 'people': 3, 'startTime': '17:20', 'wait': 12, 'status': 'entered', 'enteredTime': '17:32', 'date': '2025-04-24'},
      {'id': 3, 'phone': '01011110003', 'people': 1, 'startTime': '17:25', 'wait': 5, 'status': 'waiting', 'date': '2025-04-24'},
      {'id': 4, 'phone': '01011110004', 'people': 4, 'startTime': '17:30', 'wait': 9, 'status': 'entered', 'enteredTime': '17:39', 'date': '2025-04-24'},
      {'id': 5, 'phone': '01011110005', 'people': 2, 'startTime': '17:35', 'wait': 3, 'status': 'waiting', 'date': '2025-04-24'},
      {'id': 6, 'phone': '01011110006', 'people': 3, 'startTime': '17:40', 'wait': 8, 'status': 'entered', 'enteredTime': '17:48', 'date': '2025-04-24'},
      {'id': 7, 'phone': '01011110007', 'people': 2, 'startTime': '17:42', 'wait': 2, 'status': 'waiting', 'date': '2025-04-24'},
      {'id': 8, 'phone': '01011110008', 'people': 1, 'startTime': '17:43', 'wait': 1, 'status': 'waiting', 'date': '2025-04-24'},
      {'id': 9, 'phone': '01011110009', 'people': 4, 'startTime': '17:44', 'wait': 5, 'status': 'entered', 'enteredTime': '17:49', 'date': '2025-04-24'},
      {'id': 10, 'phone': '01011110010', 'people': 2, 'startTime': '17:45', 'wait': 0, 'status': 'waiting', 'date': '2025-04-24'},

      // 그제 날짜
      {'id': 11, 'phone': '01011110001', 'people': 2, 'startTime': '17:00', 'wait': 10, 'status': 'entered', 'enteredTime': '17:10', 'date': '2025-04-23'},
      {'id': 12, 'phone': '01011110002', 'people': 3, 'startTime': '17:05', 'wait': 6, 'status': 'entered', 'enteredTime': '17:11', 'date': '2025-04-23'},
      {'id': 13, 'phone': '01011110011', 'people': 1, 'startTime': '17:10', 'wait': 4, 'status': 'waiting', 'date': '2025-04-23'},
      {'id': 14, 'phone': '01011110012', 'people': 2, 'startTime': '17:15', 'wait': 7, 'status': 'entered', 'enteredTime': '17:22', 'date': '2025-04-23'},
      {'id': 15, 'phone': '01011110013', 'people': 2, 'startTime': '17:20', 'wait': 3, 'status': 'waiting', 'date': '2025-04-23'},
      {'id': 16, 'phone': '01011110014', 'people': 2, 'startTime': '17:22', 'wait': 5, 'status': 'waiting', 'date': '2025-04-23'},
      {'id': 17, 'phone': '01011110015', 'people': 3, 'startTime': '17:25', 'wait': 9, 'status': 'entered', 'enteredTime': '17:34', 'date': '2025-04-23'},
      {'id': 18, 'phone': '01011110016', 'people': 1, 'startTime': '17:28', 'wait': 6, 'status': 'waiting', 'date': '2025-04-23'},
      {'id': 19, 'phone': '01011110017', 'people': 4, 'startTime': '17:30', 'wait': 4, 'status': 'entered', 'enteredTime': '17:34', 'date': '2025-04-23'},
      {'id': 20, 'phone': '01011110018', 'people': 2, 'startTime': '17:32', 'wait': 0, 'status': 'waiting', 'date': '2025-04-23'},
    ];
  }

  /// 대기 → 입장 처리
  static Future<void> enterWaiting(int id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    print('입장 처리됨: ID $id');
  }

  /// 대기 → 취소 처리
  static Future<void> cancelWaiting(int id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    print('취소 처리됨: ID $id');
  }

  /// 입장 취소 → 다시 대기
  static Future<void> revertToWaiting(int id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    print('입장 취소됨 → 다시 대기: ID $id');
  }

  /// 날짜별 통계 가져오기 (더미데이터)
  static Future<Map<String, dynamic>> getStatsByDate(String date) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return {
      'visitCount': 20 + date.hashCode % 10,
      'averageWait': 5.0 + (date.hashCode % 6),
    };
  }

  /// 날짜별 방문자 수 그래프용 더미 데이터
  static Future<List<Map<String, dynamic>>> getVisitStatsGraph() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.generate(7, (index) {
      return {
        'date': '4/${18 + index}',
        'count': 15 + (index * 3 % 7),
      };
    });
  }
}