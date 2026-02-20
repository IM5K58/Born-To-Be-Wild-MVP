import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VerifyDetailScreen extends StatefulWidget {
  const VerifyDetailScreen({super.key});

  @override
  State<VerifyDetailScreen> createState() => _VerifyDetailScreenState();
}

class _VerifyDetailScreenState extends State<VerifyDetailScreen>
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
            left: -80,
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
            right: -120,
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
                                          color: Colors.red.withOpacity(0.5)),
                                      color: Colors.red.withOpacity(0.08),
                                    ),
                                    child: const Text(
                                      'STEP 03',
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
                                '03',
                                style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.red.withOpacity(0.15),
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '매일\n증명하라',
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

                      FadeTransition(
                        opacity: _contentFade,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade900.withOpacity(0.25),
                                const Color(0xFF1A1F25),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                                color: Colors.red.withOpacity(0.3)),
                          ),
                          child: const Text(
                            '"말이 아닌 사진으로 증명한다.\n오늘도, 내일도, 끝날 때까지."',
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
                              icon: '📸',
                              title: '사진 인증',
                              desc:
                                  '매일 챌린지를 수행한 사진을 업로드한다. 기상 챌린지라면 아침 사진, 운동이라면 운동 중 사진. 증거가 없으면 인정받지 못한다.',
                              accentColor: Colors.red,
                            ),
                            const SizedBox(height: 20),
                            _DetailBlock(
                              icon: '⏰',
                              title: '인증 마감 시간',
                              desc:
                                  '각 챌린지마다 인증 마감 시간이 있다. 기상 챌린지는 오전 9시, 운동 챌린지는 자정. 마감 전에 올려야 인정된다. 1분이라도 늦으면 실패다.',
                              accentColor: Colors.red,
                            ),
                            const SizedBox(height: 20),
                            _DetailBlock(
                              icon: '🚨',
                              title: '단 하루도 빠질 수 없다',
                              desc:
                                  '챌린지 기간 중 단 하루라도 인증에 실패하면, 그 즉시 챌린지는 종료된다. 변명은 없다. 아프다고, 바쁘다고 봐주지 않는다.',
                              accentColor: Colors.red,
                            ),
                            const SizedBox(height: 20),
                            _DetailBlock(
                              icon: '🤖',
                              title: 'AI 인증 검증',
                              desc:
                                  '업로드된 사진은 AI가 검증한다. 어제 찍은 사진, 인터넷에서 가져온 사진은 통과되지 않는다. 오늘, 지금, 네가 직접 한 것만 인정된다.',
                              accentColor: Colors.red,
                            ),

                            const SizedBox(height: 32),

                            // 인증 타임라인 예시
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
                                    '인증 타임라인 예시',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _TimelineItem(
                                    day: 'DAY 1',
                                    status: '✅',
                                    label: '인증 완료',
                                    color: Colors.green,
                                  ),
                                  _TimelineItem(
                                    day: 'DAY 2',
                                    status: '✅',
                                    label: '인증 완료',
                                    color: Colors.green,
                                  ),
                                  _TimelineItem(
                                    day: 'DAY 3',
                                    status: '✅',
                                    label: '인증 완료',
                                    color: Colors.green,
                                  ),
                                  _TimelineItem(
                                    day: 'DAY 4',
                                    status: '❌',
                                    label: '인증 실패 → 챌린지 종료',
                                    color: Colors.red,
                                    isLast: true,
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
                                                '02 · 잠금',
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
                                        context.push('/about/settlement'),
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
                                                '04 · 정산',
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

class _TimelineItem extends StatelessWidget {
  final String day;
  final String status;
  final String label;
  final Color color;
  final bool isLast;

  const _TimelineItem({
    required this.day,
    required this.status,
    required this.label,
    required this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(
            day,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        Column(
          children: [
            Container(
              width: 2,
              height: 12,
              color: isLast ? Colors.transparent : Colors.white.withOpacity(0.1),
            ),
            Text(status, style: const TextStyle(fontSize: 16)),
            Container(
              width: 2,
              height: 12,
              color: isLast ? Colors.transparent : Colors.white.withOpacity(0.1),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
