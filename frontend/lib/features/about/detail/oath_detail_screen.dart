import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OathDetailScreen extends StatefulWidget {
  const OathDetailScreen({super.key});

  @override
  State<OathDetailScreen> createState() => _OathDetailScreenState();
}

class _OathDetailScreenState extends State<OathDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _contentController;
  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;
  late Animation<double> _contentFade;

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
            left: -80,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.04),
              ),
            ),
          ),

          CustomScrollView(
            slivers: [
              // 앱바
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
                      // 스텝 번호 + 라벨
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
                                          color: Colors.red.withOpacity(0.5)),
                                      color: Colors.red.withOpacity(0.08),
                                    ),
                                    child: const Text(
                                      'STEP 01',
                                      style: TextStyle(
                                        color: Colors.red,
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
                                '01',
                                style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.red.withOpacity(0.15),
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '서약을\n맺으십시오.',
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
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // 핵심 인용구
                      FadeTransition(
                        opacity: _contentFade,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade900.withOpacity(0.4),
                                const Color(0xFF1A1F25),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border:
                                Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '"계약이 시작되는 순간,\n당신은 더 이상 과거의 당신이 아닙니다."',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.5,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 상세 설명
                      FadeTransition(
                        opacity: _contentFade,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _DetailBlock(
                              icon: '🎯',
                              title: '챌린지를 선택하십시오.',
                              desc:
                                  '기상, 운동, 공부, 커밋 등 당신이 정복하고 싶은 분야를 고릅니다. 남이 시키는 게 아닙니다. 당신이 진정 원하는 것을 고르십시오. 그게 진짜 동기부여의 시작입니다.',
                            ),
                            const SizedBox(height: 20),
                            _DetailBlock(
                              icon: '💰',
                              title: '보증금을 설정하십시오.',
                              desc:
                                  '얼마를 걸 것인가. 최소 1만원부터 시작할 수 있습니다. 진짜 아까운 금액을 걸어야 진심으로 움직일 수 있습니다.',
                            ),
                            const SizedBox(height: 20),
                            _DetailBlock(
                              icon: '📅',
                              title: '기간을 정하십시오.',
                              desc:
                                  '7일, 14일, 30일, 90일. 짧게 시작해도 좋습니다. 중요한 건 기간이 아니라 매일 해내는 것입니다. 단 하루도 빠짐없이.',
                            ),
                            const SizedBox(height: 20),
                            _DetailBlock(
                              icon: '🔥',
                              title: '실패 처리 방식을 선택하십시오.',
                              desc:
                                  '완전 소각, 사회 기부, 크레딧 전환 중 하나를 선택하십시오. 이 선택이 당신의 각오를 보여줍니다.',
                            ),
                            const SizedBox(height: 32),

                            // 경고 박스
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.05),
                                border: Border.all(
                                    color: Colors.red.withOpacity(0.4)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('⚠️',
                                      style: TextStyle(fontSize: 20)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '서약은 취소할 수 없습니다',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '서약을 맺는 순간, 보증금은 즉시 금고에 들어가 잠깁니다. 변심해도 돌아올 수 없습니다. 신중하게 결정하되, 결정했으면 흔들리지 마십시오.',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 13,
                                            height: 1.6,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 40),

                            // 다음 스텝으로
                            GestureDetector(
                              onTap: () => context.push('/about/lock'),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1F25),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.1)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'NEXT STEP',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 10,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          '02 · 잠금',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.arrow_forward,
                                        color: Colors.white, size: 20),
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

class _DetailBlock extends StatelessWidget {
  final String icon;
  final String title;
  final String desc;

  const _DetailBlock({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: const TextStyle(fontSize: 26)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                desc,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
