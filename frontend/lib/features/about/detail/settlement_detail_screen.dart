import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettlementDetailScreen extends StatefulWidget {
  const SettlementDetailScreen({super.key});

  @override
  State<SettlementDetailScreen> createState() => _SettlementDetailScreenState();
}

class _SettlementDetailScreenState extends State<SettlementDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _contentController;
  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;
  late Animation<double> _contentFade;

  static const Color primaryColor = Color(0xFFCE4257);
  static const Color secondaryColor = Color(0xFF720026);

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _heroFade = CurvedAnimation(parent: _heroController, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _heroController, curve: Curves.easeOut));
    _contentFade =
        CurvedAnimation(parent: _contentController, curve: Curves.easeOut);

    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _contentController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060A0E),
      body: Stack(
        children: [
          // 배경 글로우
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: secondaryColor.withOpacity(0.03),
              ),
            ),
          ),

          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: const Color(0xFF060A0E),
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                title: const Text(
                  'BEAST HEART',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    fontSize: 16,
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeTransition(
                        opacity: _heroFade,
                        child: SlideTransition(
                          position: _heroSlide,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: primaryColor.withOpacity(0.5)),
                                      color: primaryColor.withOpacity(0.08),
                                    ),
                                    child: const Text(
                                      'STEP 04',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 11,
                                        letterSpacing: 3,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Text(
                                '04',
                                style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.w900,
                                  color: primaryColor.withOpacity(0.15),
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '결과를\n받아라',
                                style: TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 1.05,
                                  letterSpacing: -1,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: 60,
                                height: 3,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      FadeTransition(
                        opacity: _contentFade,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                secondaryColor.withOpacity(0.3),
                                const Color(0xFF1A1F25),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                                color: primaryColor.withOpacity(0.3)),
                          ),
                          child: const Text(
                            '"완주하면 전액 돌아온다.\n실패하면 영원히 사라진다.\n선택은 네가 했다."',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.5,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      FadeTransition(
                        opacity: _contentFade,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 성공 케이스
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.05),
                                border: Border.all(
                                    color: Colors.green.withOpacity(0.3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text('🏆',
                                          style: TextStyle(fontSize: 24)),
                                      const SizedBox(width: 12),
                                      const Text(
                                        '완주 성공',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _ResultItem(
                                    label: '보증금',
                                    value: '전액 반환',
                                    color: Colors.green,
                                  ),
                                  const SizedBox(height: 8),
                                  _ResultItem(
                                    label: '수수료',
                                    value: '없음',
                                    color: Colors.green,
                                  ),
                                  const SizedBox(height: 8),
                                  _ResultItem(
                                    label: '추가 보상',
                                    value: '완주 배지 + 연속 기록',
                                    color: Colors.green,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    '챌린지 종료 후 24시간 이내에 등록된 계좌로 전액 입금된다. 단 한 푼도 빠지지 않는다. 이게 네가 받아야 할 것이다.',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 13,
                                      height: 1.7,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // 실패 케이스
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.05),
                                border: Border.all(
                                    color: primaryColor.withOpacity(0.3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text('💀',
                                          style: TextStyle(fontSize: 24)),
                                      const SizedBox(width: 12),
                                      const Text(
                                        '챌린지 실패',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    '실패 처리 방식 (서약 시 선택)',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _FailureOption(
                                    icon: '🔥',
                                    title: '완전 소각',
                                    desc: '보증금이 영구 소멸된다. 어디에도 가지 않는다.',
                                    color: primaryColor,
                                  ),
                                  const SizedBox(height: 10),
                                  _FailureOption(
                                    icon: '🤝',
                                    title: '사회 기부',
                                    desc: '선택한 기관에 기부된다. 실패가 선행이 된다.',
                                    color: Colors.teal,
                                  ),
                                  const SizedBox(height: 10),
                                  _FailureOption(
                                    icon: '💎',
                                    title: '크레딧 전환 (최초 1회)',
                                    desc: '재도전 크레딧으로 전환. 단 한 번만 허용된다.',
                                    color: Colors.amber,
                                    badge: '1회 한정',
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // 정산 타이밍
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1F25),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.08)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '정산 타이밍',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _TimingRow(
                                    label: '완주 성공 시',
                                    value: '챌린지 종료 후 24시간 이내',
                                    color: Colors.green,
                                  ),
                                  const SizedBox(height: 10),
                                  _TimingRow(
                                    label: '인증 실패 시',
                                    value: '실패 확정 즉시',
                                    color: primaryColor,
                                  ),
                                  const SizedBox(height: 10),
                                  _TimingRow(
                                    label: '기부 처리',
                                    value: '실패 확정 후 48시간 이내',
                                    color: Colors.teal,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 40),

                            // 마지막 CTA
                            GestureDetector(
                              onTap: () => context.push('/auth'),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      secondaryColor,
                                      const Color(0xFF1A0000),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                      color: primaryColor.withOpacity(0.5)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '이제 알았다.\n시작할 준비가 됐냐.',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      color: Colors.white,
                                      child: const Center(
                                        child: Text(
                                          '🩸  피의 서약 맺기',
                                          style: TextStyle(
                                            color: secondaryColor,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // 이전 네비게이션
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1F25),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.1)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.arrow_back,
                                        color: Colors.white, size: 16),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'PREV',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 10,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                        const Text(
                                          '03 · 인증',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ResultItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[500], fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _FailureOption extends StatelessWidget {
  final String icon;
  final String title;
  final String desc;
  final Color color;
  final String? badge;

  const _FailureOption({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          border: Border.all(color: color.withOpacity(0.5)),
                          color: color.withOpacity(0.1),
                        ),
                        child: Text(
                          badge!,
                          style: TextStyle(
                              color: color,
                              fontSize: 9,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(
                      color: Colors.grey[500], fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimingRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TimingRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[500], fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
