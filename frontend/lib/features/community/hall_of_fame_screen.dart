import 'package:flutter/material.dart';

class HallOfFameScreen extends StatelessWidget {
  const HallOfFameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFCE4257);
    const secondaryColor = Color(0xFF720026);

    final rankings = [
      {'rank': 1, 'name': '김야수', 'streak': 120, 'points': 15400, 'badge': '🔥'},
      {'rank': 2, 'name': '정투사', 'streak': 98, 'points': 12800, 'badge': '💻'},
      {'rank': 3, 'name': '최전사', 'streak': 85, 'points': 11200, 'badge': '🤝'},
      {'rank': 4, 'name': '이강인', 'streak': 72, 'points': 9800, 'badge': '🌅'},
      {'rank': 5, 'name': '박의지', 'streak': 65, 'points': 8500, 'badge': '🏋️'},
      {'rank': 6, 'name': '한끈기', 'streak': 50, 'points': 7200, 'badge': '📚'},
      {'rank': 7, 'name': '임불굴', 'streak': 42, 'points': 6500, 'badge': '🏃'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14),
        title: const Text('명예의 전당', style: TextStyle(fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // 상단 요약 정보
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [secondaryColor, const Color(0xFF1A1F25)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 48),
                const SizedBox(height: 12),
                const Text(
                  '최고의 야수들',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                Text(
                  '현재까지 가장 많은 증명을 해낸 전사들입니다.',
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
              ],
            ),
          ),

          // 랭킹 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: rankings.length,
              itemBuilder: (context, index) {
                final item = rankings[index];
                final isTop3 = (item['rank'] as int) <= 3;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F25),
                    border: Border.all(
                      color: isTop3 ? primaryColor.withOpacity(0.4) : Colors.white.withOpacity(0.05),
                    ),
                  ),
                  child: Row(
                    children: [
                      // 순위
                      SizedBox(
                        width: 40,
                        child: Text(
                          '#${item['rank']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: isTop3 ? primaryColor : Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 프로필 아이콘/뱃지
                      CircleAvatar(
                        backgroundColor: const Color(0xFF0B0F14),
                        child: Text(item['badge'] as String, style: const TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(width: 16),
                      // 이름 및 상세 정보
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'] as String,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item['streak']}일 연속 스트릭',
                              style: TextStyle(color: Colors.grey[500], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      // 포인트
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${item['points']} PT',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                          ),
                          const Text(
                            '누적 활동 점수',
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
