import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'challenge_repository.dart';

class CreateChallengeScreen extends ConsumerStatefulWidget {
  const CreateChallengeScreen({super.key});

  @override
  ConsumerState<CreateChallengeScreen> createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends ConsumerState<CreateChallengeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController(text: '10000');
  String _selectedTemplate = 'wakeup';

  final List<Map<String, String>> _templates = [
    {'id': 'wakeup', 'label': '🌅 기상 챌린지'},
    {'id': 'commit', 'label': '💻 커밋 챌린지'},
    {'id': 'gym', 'label': '🏋️ 헬스 챌린지'},
    {'id': 'study', 'label': '📚 공부 챌린지'},
    {'id': 'running', 'label': '🏃 러닝 챌린지'},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(createChallengeProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        ref.read(createChallengeProvider.notifier).reset();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('챌린지가 시작되었습니다! 화이팅! 💪')),
        );
        context.go('/');
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류: ${next.error}')),
        );
      }
    });

    final state = ref.watch(createChallengeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('새 챌린지 시작')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('챌린지 종류', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedTemplate,
                items: _templates
                    .map((t) => DropdownMenuItem(value: t['id'], child: Text(t['label']!)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedTemplate = val!),
              ),
              const SizedBox(height: 24),

              const Text('보증금 금액 (원)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  suffixText: '원',
                  hintText: '최소 1,000원 이상',
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return '금액을 입력해주세요';
                  final n = int.tryParse(val);
                  if (n == null) return '숫자만 입력해주세요';
                  if (n < 1000) return '최소 1,000원 이상이어야 합니다';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              const Text('챌린지 조건', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• 기간: 30일'),
                      SizedBox(height: 4),
                      Text('• 인증 빈도: 매일'),
                      SizedBox(height: 4),
                      Text('• 실패 시: 보증금 100% 소각 🔥'),
                    ],
                  ),
                ),
              ),

              const Spacer(),
              if (state.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.lock),
                  label: const Text('보증금 걸고 시작하기'),
                  onPressed: _submit,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = int.parse(_amountController.text);
      ref.read(createChallengeProvider.notifier).createAndActivate(
        templateId: _selectedTemplate,
        amount: amount,
      );
    }
  }
}
