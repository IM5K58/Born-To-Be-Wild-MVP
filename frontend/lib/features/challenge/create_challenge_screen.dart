import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'challenge_repository.dart';

// 기부 기관 목록
const List<Map<String, String>> kDonateTargets = [
  {'id': 'unicef', 'name': '유니세프 (UNICEF)', 'desc': '전 세계 어린이 지원'},
  {'id': 'greenpeace', 'name': '그린피스 (Greenpeace)', 'desc': '환경 보호 단체'},
  {'id': 'save_children', 'name': '세이브더칠드런', 'desc': '아동 권리 보호'},
  {'id': 'wwf', 'name': 'WWF (세계자연기금)', 'desc': '자연 생태계 보전'},
  {'id': 'red_cross', 'name': '대한적십자사', 'desc': '재난 구호 및 헌혈'},
];

class CreateChallengeScreen extends ConsumerStatefulWidget {
  const CreateChallengeScreen({super.key});

  @override
  ConsumerState<CreateChallengeScreen> createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends ConsumerState<CreateChallengeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController(text: '10000');
  String _selectedTemplate = 'wakeup';
  String _failureRule = 'BURN'; // 'BURN' | 'CREDIT' | 'DONATE'
  String _donateTarget = 'unicef';

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
      backgroundColor: const Color(0xFF0B0F14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14),
        title: const Text('새 서약 맺기', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ── 챌린지 종류 ──────────────────────────────
              _SectionTitle('챌린지 종류'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedTemplate,
                dropdownColor: const Color(0xFF1A1F25),
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(),
                items: _templates
                    .map((t) => DropdownMenuItem(value: t['id'], child: Text(t['label']!)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedTemplate = val!),
              ),

              const SizedBox(height: 24),

              // ── 보증금 금액 ──────────────────────────────
              _SectionTitle('보증금 금액'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(suffix: '원', hint: '최소 1,000원 이상'),
                validator: (val) {
                  if (val == null || val.isEmpty) return '금액을 입력해주세요';
                  final n = int.tryParse(val);
                  if (n == null) return '숫자만 입력해주세요';
                  if (n < 1000) return '최소 1,000원 이상이어야 합니다';
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // ── 소각 방식 ────────────────────────────────
              _SectionTitle('실패 시 소각 방식'),
              const SizedBox(height: 4),
              Text(
                '챌린지 실패 시 보증금을 어떻게 처리할지 선택하세요',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 12),

              _FailureRuleCard(
                value: 'BURN',
                selected: _failureRule == 'BURN',
                icon: '🔥',
                title: '완전 소각',
                desc: '보증금이 완전히 소각됩니다. 가장 강력한 동기부여.',
                onTap: () => setState(() => _failureRule = 'BURN'),
              ),
              const SizedBox(height: 8),

              _FailureRuleCard(
                value: 'CREDIT',
                selected: _failureRule == 'CREDIT',
                icon: '💎',
                title: '앱 크레딧 전환 (최초 1회)',
                desc: '보증금이 앱 내 크레딧으로 전환됩니다. 재도전 시 사용 가능. 단, 평생 1회만 선택 가능.',
                onTap: () => setState(() => _failureRule = 'CREDIT'),
                badge: '1회 한정',
                badgeColor: Colors.amber,
              ),
              const SizedBox(height: 8),

              _FailureRuleCard(
                value: 'DONATE',
                selected: _failureRule == 'DONATE',
                icon: '🤝',
                title: '사회 기부',
                desc: '보증금이 선택한 기관에 기부됩니다.',
                onTap: () => setState(() => _failureRule = 'DONATE'),
              ),

              // 기부 기관 선택 (DONATE 선택 시만 표시)
              if (_failureRule == 'DONATE') ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F25),
                    border: Border.all(color: Colors.teal.withOpacity(0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('기부 기관 선택', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 12),
                      ...kDonateTargets.map((org) => RadioListTile<String>(
                        value: org['id']!,
                        groupValue: _donateTarget,
                        activeColor: Colors.teal,
                        contentPadding: EdgeInsets.zero,
                        title: Text(org['name']!, style: const TextStyle(color: Colors.white, fontSize: 14)),
                        subtitle: Text(org['desc']!, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        onChanged: (val) => setState(() => _donateTarget = val!),
                      )),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // ── 계약 조건 요약 ───────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F25),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📋 계약 조건', style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1)),
                    const SizedBox(height: 10),
                    const Text('• 기간: 30일', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 4),
                    const Text('• 인증 빈도: 매일', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 4),
                    Text(
                      '• 실패 패널티: ${_failureRuleLabel()}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              if (state.isLoading)
                const Center(child: CircularProgressIndicator(color: Colors.red))
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.bloodtype),
                  label: const Text('피의 서약 맺기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _submit,
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _failureRuleLabel() {
    switch (_failureRule) {
      case 'CREDIT': return '앱 크레딧 전환 (1회 한정)';
      case 'DONATE': return '${kDonateTargets.firstWhere((o) => o['id'] == _donateTarget)['name']} 기부';
      default: return '보증금 100% 소각 🔥';
    }
  }

  InputDecoration _inputDecoration({String? suffix, String? hint}) {
    return InputDecoration(
      suffixText: suffix,
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[700]),
      filled: true,
      fillColor: const Color(0xFF1A1F25),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = int.parse(_amountController.text);
      ref.read(createChallengeProvider.notifier).createAndActivate(
        templateId: _selectedTemplate,
        amount: amount,
        failureRule: _failureRule,
        donateTarget: _failureRule == 'DONATE' ? _donateTarget : null,
      );
    }
  }
}

// ── 소각 방식 선택 카드 ─────────────────────────────────────────
class _FailureRuleCard extends StatelessWidget {
  final String value;
  final bool selected;
  final String icon;
  final String title;
  final String desc;
  final VoidCallback onTap;
  final String? badge;
  final Color? badgeColor;

  const _FailureRuleCard({
    required this.value,
    required this.selected,
    required this.icon,
    required this.title,
    required this.desc,
    required this.onTap,
    this.badge,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? Colors.red.withOpacity(0.08) : const Color(0xFF1A1F25),
          border: Border.all(
            color: selected ? Colors.red : Colors.white.withOpacity(0.08),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.grey[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: (badgeColor ?? Colors.grey).withOpacity(0.2),
                            border: Border.all(color: badgeColor ?? Colors.grey, width: 0.5),
                          ),
                          child: Text(
                            badge!,
                            style: TextStyle(color: badgeColor ?? Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(desc, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: selected ? Colors.red : Colors.grey, width: 2),
                color: selected ? Colors.red : Colors.transparent,
              ),
              child: selected ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── 섹션 타이틀 ─────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
