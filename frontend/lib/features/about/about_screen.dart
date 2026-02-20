import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(8, (_) => GlobalKey());
  final List<bool> _visible = List.generate(8, (_) => false);

  static const Color primaryColor = Color(0xFFCE4257);
  static const Color secondaryColor = Color(0xFF720026);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // 첫 번째 섹션은 바로 표시
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _visible[0] = true);
    });
  }

  void _onScroll() {
    final screenHeight = MediaQuery.of(context).size.height;
    for (int i = 0; i < _sectionKeys.length; i++) {
      if (_visible[i]) continue;
      final ctx = _sectionKeys[i].currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final pos = box.localToGlobal(Offset.zero);
      if (pos.dy < screenHeight * 0.88) {
        setState(() => _visible[i] = true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060A0E),
      body: Stack(
        children: [
          // 배경 그라디언트 효과
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.04),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            right: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: secondaryColor.withOpacity(0.03),
              ),
            ),
          ),

          // 메인 스크롤
          CustomScrollView(
            controller: _scrollController,
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
                actions: [
                  TextButton(
                    onPressed: () => context.push('/auth'),
                    child: const Text('시작하기', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),

              SliverList(
                delegate: SliverChildListDelegate([
                  // ── 섹션 0: 히어로 ─────────────────────────────
                  _AnimatedSection(
                    key: _sectionKeys[0],
                    visible: _visible[0],
                    delay: 0,
                    child: _HeroSection(),
                  ),

                  // ── 섹션 1: 도발 ───────────────────────────────
                  _AnimatedSection(
                    key: _sectionKeys[1],
                    visible: _visible[1],
                    delay: 0,
                    child: _ProvokeSection(),
                  ),

                  // ── 섹션 2: 문제 제기 ──────────────────────────
                  _AnimatedSection(
                    key: _sectionKeys[2],
                    visible: _visible[2],
                    delay: 0,
                    child: _ProblemSection(),
                  ),

                  // ── 섹션 3: 해결책 ─────────────────────────────
                  _AnimatedSection(
                    key: _sectionKeys[3],
                    visible: _visible[3],
                    delay: 0,
                    child: _SolutionSection(),
                  ),

                  // ── 섹션 4: 작동 방식 ──────────────────────────
                  _AnimatedSection(
                    key: _sectionKeys[4],
                    visible: _visible[4],
                    delay: 0,
                    child: _HowItWorksSection(),
                  ),

                  // ── 섹션 5: 소각 방식 ──────────────────────────
                  _AnimatedSection(
                    key: _sectionKeys[5],
                    visible: _visible[5],
                    delay: 0,
                    child: _BurnSection(),
                  ),

                  // ── 섹션 6: 챌린지 종류 ────────────────────────
                  _AnimatedSection(
                    key: _sectionKeys[6],
                    visible: _visible[6],
                    delay: 0,
                    child: _ChallengeTypesSection(),
                  ),

                  // ── 섹션 7: 최종 CTA ───────────────────────────
                  _AnimatedSection(
                    key: _sectionKeys[7],
                    visible: _visible[7],
                    delay: 0,
                    child: _FinalCtaSection(),
                  ),

                  const SizedBox(height: 60),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── 애니메이션 래퍼 ───────────────────────────────────────────────
class _AnimatedSection extends StatelessWidget {
  final Widget child;
  final bool visible;
  final int delay;

  const _AnimatedSection({
    super.key,
    required this.child,
    required this.visible,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, 0.08),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOut,
        child: child,
      ),
    );
  }
}

// ── 섹션 0: 히어로 ────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFCE4257);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 60, 28, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor.withOpacity(0.5)),
              color: primaryColor.withOpacity(0.08),
            ),
            child: const Text(
              '⚔️  BEAST HEART',
              style: TextStyle(color: primaryColor, fontSize: 12, letterSpacing: 3, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            '변명은\n필요없습니다.',
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.05,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '보증금을 거십시오.\n매일 증명하십시오.\n아니면 소각될 뿐입니다.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[400],
              height: 1.8,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 32),
          // 핵심 대사 1
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: primaryColor, width: 3)),
            ),
            child: const Text(
              '심장이 시키는 일에\n이유를 묻지 마십시오.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.4,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: 60,
            height: 3,
            color: primaryColor,
          ),
        ],
      ),
    );
  }
}

// ── 섹션 1: 도발 ──────────────────────────────────────────────────
class _ProvokeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFCE4257);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.06),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '"내일부터 할게."',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '그 내일이 몇 번째입니까?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
              height: 1.7,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '작심삼일. 의지력을 탓하지 마십시오.\n시스템은 저희가 만들어 드리겠습니다.\n이제 네 돈이 당신을 강제합니다.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[300],
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ── 섹션 2: 문제 제기 ─────────────────────────────────────────────
class _ProblemSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final problems = [
      {'icon': '😮‍💨', 'text': '작심삼일. 또 실패했다.'},
      {'icon': '📱', 'text': '앱 알림? 무시하면 그만이다.'},
      {'icon': '🤝', 'text': '친구와 약속? 서로 봐준다.'},
      {'icon': '📓', 'text': '일기장? 아무도 모른다.'},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('문제'),
          const SizedBox(height: 12),
          const Text(
            '기존 방법은\n전부 구멍이 있었습니다.',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 28),
          ...problems.map((p) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                Text(p['icon']!, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 16),
                Text(
                  p['text']!,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// ── 섹션 3: 해결책 ────────────────────────────────────────────────
class _SolutionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFCE4257);
    const secondaryColor = Color(0xFF720026);
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            secondaryColor.withOpacity(0.5),
            const Color(0xFF1A1F25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: primaryColor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('해결책'),
          const SizedBox(height: 16),
          const Text(
            '본인을 움직이게 할 제약을 만드십시오.',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '인간은 이익보다 손실에 2배 민감합니다.\n심리학이 증명한 사실입니다.\n\n당신이 건 보증금은 실패하는 순간\n사회로 환원됩니다.\n그게 진짜 동기부여의 시작입니다.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[300],
              height: 1.9,
            ),
          ),
          const SizedBox(height: 24),
          // 핵심 대사 2
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white.withOpacity(0.04),
            child: const Text(
              'High Risk, High Return?\nNo.\nOnly High Return.',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.5,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.psychology, color: primaryColor, size: 18),
              const SizedBox(width: 8),
              Text(
                '손실 회피 심리 (Loss Aversion)',
                style: TextStyle(color: primaryColor.withOpacity(0.7), fontSize: 13, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── 섹션 4: 작동 방식 ─────────────────────────────────────────────
class _HowItWorksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFCE4257);
    final steps = [
      {
        'num': '01',
        'title': '서약을 맺으십시오.',
        'desc': '챌린지를 고르고 보증금을 설정하십시오.\n이 순간부터 계약이 시작됩니다.',
        'color': primaryColor,
        'route': '/about/oath',
      },
      {
        'num': '02',
        'title': '보증금을 거십시오.',
        'desc': '당신의 돈이 챌린지 금고에 들어간 뒤 잠깁니다.\n챌린지가 끝나기 전엔 꺼낼 수 없습니다.',
        'color': primaryColor,
        'route': '/about/lock',
      },
      {
        'num': '03',
        'title': '매일 증명하십시오.',
        'desc': '사진으로 인증하십시오.\n핑계는 없습니다. 오늘도 해야 합니다.',
        'color': primaryColor,
        'route': '/about/verify',
      },
      {
        'num': '04',
        'title': '마땅한 보상을 받으십시오.',
        'desc': '완주하면 보증금 전액을 반환하고 특별한 혜택이 주어집니다..\n실패하면? 거기서 끝입니다.',
        'color': primaryColor,
        'route': '/about/settlement',
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('작동 방식'),
          const SizedBox(height: 12),
          const Text(
            '단순합니다.\n그래서 더 강해질 수 있습니다.',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '각 단계를 눌러 자세히 알아보십시오.',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          ...steps.map((step) => _StepCard(
            num: step['num'] as String,
            title: step['title'] as String,
            desc: step['desc'] as String,
            color: step['color'] as Color,
            route: step['route'] as String,
          )),
        ],
      ),
    );
  }
}

class _StepCard extends StatefulWidget {
  final String num;
  final String title;
  final String desc;
  final Color color;
  final String route;

  const _StepCard({
    required this.num,
    required this.title,
    required this.desc,
    required this.color,
    required this.route,
  });

  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () => context.push(widget.route),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _isHovered
                  ? widget.color.withOpacity(0.08)
                  : widget.color.withOpacity(0.04),
              border: Border.all(
                color: _isHovered
                    ? widget.color.withOpacity(0.5)
                    : widget.color.withOpacity(0.15),
                width: _isHovered ? 1.5 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.num,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: widget.color.withOpacity(_isHovered ? 0.5 : 0.3),
                    height: 1,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: widget.color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.desc,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AnimatedOpacity(
                        opacity: _isHovered ? 1.0 : 0.5,
                        duration: const Duration(milliseconds: 200),
                        child: Row(
                          children: [
                            Text(
                              '자세히 보기',
                              style: TextStyle(
                                color: widget.color,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              color: widget.color,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(
                      _isHovered ? 4 : 0, 0, 0),
                  child: Icon(
                    Icons.chevron_right,
                    color: widget.color.withOpacity(_isHovered ? 0.8 : 0.3),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── 섹션 5: 소각 방식 ─────────────────────────────────────────────
class _BurnSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFCE4257);
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F25),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('실패 시 처리'),
          const SizedBox(height: 12),
          const Text(
            '당신이 선택합니다.\n소각 방식까지.',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 28),
          const _BurnOption(
            icon: '🔥',
            title: '완전 소각',
            desc: '보증금이 영원히 사라집니다.\n가장 강력한 동기부여가 될 수 있습니다.',
            color: primaryColor,
          ),
          const SizedBox(height: 16),
          const _BurnOption(
            icon: '🤝',
            title: '사회 기부',
            desc: '유니세프, 그린피스 등 선택한 기관에 기부됩니다.\n 당신의 실패를 세상을 돕는 데 사용하십시오.',
            color: Colors.teal,
          ),
          const SizedBox(height: 16),
          const _BurnOption(
            icon: '💎',
            title: '크레딧 전환 (최초 1회)',
            desc: '딱 한 번만 허용됩니다.\n 실패 시 재도전에 사용 가능한 크레딧으로 전환됩니다.',
            color: Colors.amber,
            badge: '1회 한정',
          ),
        ],
      ),
    );
  }
}

class _BurnOption extends StatelessWidget {
  final String icon;
  final String title;
  final String desc;
  final Color color;
  final String? badge;

  const _BurnOption({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: color.withOpacity(0.5)),
                          color: color.withOpacity(0.1),
                        ),
                        child: Text(badge!, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(desc, style: TextStyle(color: Colors.grey[500], fontSize: 13, height: 1.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── 섹션 6: 챌린지 종류 ───────────────────────────────────────────
class _ChallengeTypesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final challenges = [
      {'emoji': '🌅', 'name': '기상 챌린지', 'desc': '매일 아침 일어나는 것조차\n못 하면서 뭘 하겠습니까.'},
      {'emoji': '💻', 'name': '커밋 챌린지', 'desc': '개발자라면 매일 코드를 쓰십시오.\n잔디가 비면 돈이 탑니다.'},
      {'emoji': '🏋️', 'name': '헬스 챌린지', 'desc': '몸은 거짓말하지 않습니다.\n매일 증명하십시오.'},
      {'emoji': '📚', 'name': '공부 챌린지', 'desc': '지식은 하루아침에 쌓이지 않습니다.\n꾸준함이 전부입니다.'},
      {'emoji': '🏃', 'name': '러닝 챌린지', 'desc': '뛰십시오. 멈추면 돈이 사라집니다.\n그게 전부입니다.'},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('챌린지 종류'),
          const SizedBox(height: 12),
          const Text(
            '어떤 분야든\n상관없습니다.',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          // 핵심 대사 3
          Text(
            '양 떼 속에 숨지 마십시오.\n포효하는 법을 알려주겠습니다.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[500],
              height: 1.7,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 28),
          ...challenges.map((c) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F25),
              border: Border.all(color: Colors.white.withOpacity(0.07)),
            ),
            child: Row(
              children: [
                Text(c['emoji']!, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c['name']!,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        c['desc']!,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// ── 섹션 7: 최종 CTA ──────────────────────────────────────────────
class _FinalCtaSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFCE4257);
    const secondaryColor = Color(0xFF720026);
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            secondaryColor,
            const Color(0xFF1A0000),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: primaryColor.withOpacity(0.5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '아직도\n생각만 하고 있습니까?',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 20),
          // 핵심 대사 4
          Text(
            '언제까지 겁쟁이 마냥 도망칠겁니까.',
            style: TextStyle(
              fontSize: 18,
              color: primaryColor.withOpacity(0.7),
              height: 1.7,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '야수의 심장을 가진 채 살아봅시다.',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              height: 1.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/auth'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: secondaryColor,
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              child: const Text('🩸  피의 서약 맺기'),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '변명은 필요없습니다다. 결과만 있을 뿐입니다. 증명하십시오.',
              style: TextStyle(color: primaryColor.withOpacity(0.6), fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 공통 섹션 라벨 ────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFCE4257);
    return Row(
      children: [
        Container(width: 3, height: 14, color: primaryColor),
        const SizedBox(width: 8),
        Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: primaryColor,
            fontSize: 11,
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
