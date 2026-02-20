import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFCE4257);
    const secondaryColor = Color(0xFF720026);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14),
        title: const Text(
          '커뮤니티',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 섹션 1: 명예의 전당 (Hall of Fame) ──────────────────────────
            GestureDetector(
              onTap: () => context.push('/community/hof'),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _SectionHeader(title: '명예의 전당', primaryColor: primaryColor),
                        Row(
                          children: [
                            Text('전체 순위', style: TextStyle(color: primaryColor, fontSize: 13, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios, color: primaryColor, size: 12),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _HallOfFameSection(primaryColor: primaryColor, secondaryColor: secondaryColor),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── 섹션 2: 커뮤니티 소통 (Community Feed) ─────────────────────────────
            _SectionHeader(title: '커뮤니티 소통', primaryColor: primaryColor),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '야수의 심장을 가진 이들의 소통 창구',
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
            _CommunityTopicSection(primaryColor: primaryColor),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color primaryColor;

  const _SectionHeader({required this.title, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(width: 4, height: 16, color: primaryColor),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _HallOfFameSection extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const _HallOfFameSection({required this.primaryColor, required this.secondaryColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 기부금 현황 카드
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [secondaryColor, const Color(0xFF1A1F25)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: primaryColor.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('누적 소각 및 기부금', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Text(
                    '₩ 12,450,000',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.trending_up, color: Colors.green, size: 20),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _MiniStat(label: '완전 소각', value: '₩ 8,200,000', color: primaryColor),
                  _MiniStat(label: '사회 기부', value: '₩ 4,250,000', color: Colors.teal),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // 스트릭 & 뱃지 리더보드 (가로 스크롤)
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _HofCard(name: '김야수', detail: '120일 연속 스트릭', icon: '🔥', primaryColor: primaryColor),
              _HofCard(name: '정투사', detail: '커밋 챌린지 50회 완주', icon: '💻', primaryColor: primaryColor),
              _HofCard(name: '이강인', detail: '기상 뱃지 수집가', icon: '🌅', primaryColor: primaryColor),
              _HofCard(name: '최전사', detail: '누적 기부금 1위', icon: '🤝', primaryColor: primaryColor),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}

class _HofCard extends StatelessWidget {
  final String name;
  final String detail;
  final String icon;
  final Color primaryColor;

  const _HofCard({required this.name, required this.detail, required this.icon, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F25),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(
            detail,
            style: TextStyle(color: Colors.grey[500], fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CommunityTopicSection extends StatelessWidget {
  final Color primaryColor;

  const _CommunityTopicSection({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final topics = [
      {'title': '새벽 5시 미라클 모닝 팀', 'count': 124, 'tag': '기상', 'route': '/community/miracle-morning'},
      {'title': '1일 1커밋 지옥의 레이스', 'count': 89, 'tag': '개발', 'route': null},
      {'title': '3대 500 찍기 전엔 못 나감', 'count': 56, 'tag': '운동', 'route': null},
      {'title': '매일 영어 원서 읽기 모임', 'count': 42, 'tag': '공부', 'route': null},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: topics.length,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (context, index) {
        final topic = topics[index];
        final route = topic['route'] as String?;

        return GestureDetector(
          onTap: route != null ? () => context.push(route) : null,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F25),
              border: Border.all(
                color: route != null ? primaryColor.withOpacity(0.3) : Colors.white.withOpacity(0.05),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryColor.withOpacity(0.5)),
                              color: primaryColor.withOpacity(0.1),
                            ),
                            child: Text(
                              topic['tag'] as String,
                              style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '참여 ${topic['count']}명',
                            style: TextStyle(color: Colors.grey[600], fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        topic['title'] as String,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Icon(
                  route != null ? Icons.arrow_forward_ios : Icons.chat_bubble_outline,
                  color: primaryColor.withOpacity(0.5),
                  size: route != null ? 14 : 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
