import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EnterWaitPage extends StatefulWidget {
  const EnterWaitPage({super.key});

  @override
  State<EnterWaitPage> createState() => _EnterWaitPageState();
}

class _EnterWaitPageState extends State<EnterWaitPage> {
  final phoneController = TextEditingController();

  final phoneMaskFormatter = MaskTextInputFormatter(
      mask: '###-####-####',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy,);

  int peopleCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('대기 등록')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('휴대폰 번호를 입력하고 웨이팅 번호를 확인하세요!'),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [phoneMaskFormatter], //숫자만 입력
              decoration: const InputDecoration(hintText: '010-0000-0000'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text('인원 수 선택'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (peopleCount > 1) {
                      setState(() {
                        peopleCount--;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text('$peopleCount 명', style: const TextStyle(fontSize: 20)),
                IconButton(
                  onPressed: () {
                    setState(() {
                      peopleCount++;
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final phone = phoneController.text.trim();

                if (phone.isEmpty || phone.length < 13) {
                  // 입력 안 했거나 형식 이상할 때
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('입력 오류'),
                      content: const Text('전화번호를 정확히 입력해주세요.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('확인'),
                        )
                      ],
                    ),
                  );
                  return;
                }

                // 정상 등록 처리
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: const Text('웨이팅이 접수되었습니다!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // dialog 닫기
                          Navigator.pop(context); // 이전 화면으로
                        },
                        child: const Text('확인'),
                      )
                    ],
                  ),
                );
              },
              child: const Text('대기 등록'),
            )

          ],
        ),
      ),
    );
  }
}