import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LockDetailScreen extends StatefulWidget {
  const LockDetailScreen({super.key});

  @override
  State<LockDetailScreen> createState() => _LockDetailScreenState();
}

class _LockDetailScreenState extends State<LockDetailScreen>
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
                                          color:
                                              primaryColor.withOpacity(0.5)),
                                      color: primaryColor.withOpacity(0.08),
                                    ),
                                    child: const Text(
                                      'STEP 02',
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
                                '02',
                                style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.w900,
                                  color: primaryColor.withOpacity(0.15),
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '보증금을\n잠구십시오',
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
                            '"금고에 들어간 돈은\n챌린지가 끝나기 전까지\n절대 꺼낼 수 없습니다."',
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
                            _DetailBlock(
                              icon: '🔒',
                              title: '즉시 에스크로 처리',
                              desc:
                                  '서약 완료 즉시 보증금은 에스크로 계좌로 이동됩니다. 당신 계좌에서 빠져나가는 순간, 챌린지를 완주해야만 돌아오는 또 다른 목표가 됩니다.',
                              accentColor: primaryColor,
                            ),
                            const SizedBox(height: 20),
                            _DetailBlock(
                              icon: '🚫',
                              title: '중도 인출 불가',
                              desc:
                                  '어떤 이유로도 챌린지 도중에 돈을 꺼낼 수 없습니다. 급전이 필요해도, 마음이 바뀌어도, 불가능합니다. 이것이 진짜 강제력입니다.',
                              accentColor: primaryColor,
                            ),
                            const SizedBox(height: 20),
                            _DetailBlock(
                              icon: '🛡️',
                              title: '안전한 보관',
                              desc:
                                  '잠긴 보증금은 안전하게 보관됩니다. 챌린지를 완주하면 수수료 없이 전액 반환됩니다. 당신이 해내면 단 한 푼도 잃지 않습니다.',
                              accentColor: primaryColor,
                            ),
                            const SizedBox(height: 20),
                            _DetailBlock(
                              icon: '⏱️',
                              title: '챌린지 기간 동안 유지',
                              desc:
                                  '7일이든 90일이든, 설정한 기간이 끝날 때까지 잠금은 유지됩니다. 시간이 지날수록 압박감은 커지고, 의지력도 강해집니다. 그게 바로 이 시스템의 힘입니다.',
                              accentColor: primaryColor,
                            ),

                            const SizedBox(height: 32),

                            // 심리학적 근거 박스
                            Container(
                              padding: const EdgeInsets.all(20),
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
                                      const Icon(Icons.psychology,
                                          color: primaryColor, size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        '손실 회피 심리 (Loss Aversion)',
                                        style: TextStyle(
                                          color: primaryColor.withOpacity(0.8),
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '행동경제학 연구에 따르면, 인간은 같은 금액의 이익보다 손실에 약 2배 더 강하게 반응합니다. 잠긴 보증금은 매 순간 "잃을 수 있다"는 압박을 줍니다. 이것이 진짜 동기부여의 시작입니다.',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 13,
                                      height: 1.7,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 40),

                            // 이전/다음 네비게이션
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => context.pop(),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1A1F25),
                                        border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.1)),
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
                                                '01 · 서약',
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
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        context.push('/about/verify'),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1A1F25),
                                        border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.1)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'NEXT',
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
                                          const SizedBox(width: 8),
                                          const Icon(Icons.arrow_forward,
                                              color: Colors.white, size: 16),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
  final Color accentColor;

  const _DetailBlock({
    required this.icon,
    required this.title,
    required this.desc,
    required this.accentColor,
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
                style: TextStyle(
                  color: accentColor,
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
