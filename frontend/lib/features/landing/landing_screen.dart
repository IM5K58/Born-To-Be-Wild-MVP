import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_provider.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 앱바
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'BEAST HEART',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  if (user != null)
                    GestureDetector(
                      onTap: () {
                        ref.read(authStateProvider.notifier).logout();
                        context.go('/auth');
                      },
                      child: Row(
                        children: [
                          Text(
                            user.nickname ?? '',
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.logout, color: Colors.grey, size: 16),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // 히어로 섹션
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.shade900.withOpacity(0.6),
                            const Color(0xFF1A1F25),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '작심삼일을\n이겨내는 방법',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '보증금을 걸고 매일 인증하세요.\n실패하면 보증금이 소각됩니다.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 메뉴 섹션 타이틀
                    const Text(
                      '서비스',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 피의 서약 카드 (메인 CTA)
                    _BloodOathCard(onTap: () => context.push('/oath')),

                    const SizedBox(height: 12),

                    // 오늘의 챌린지 현황 카드
                    _MenuCard(
                      icon: Icons.today,
                      iconColor: Colors.cyan,
                      title: '오늘의 챌린지 현황',
                      subtitle: '오늘 아직 인증하지 않은 챌린지를 확인하세요',
                      onTap: () => context.push('/dashboard'),
                    ),

                    const SizedBox(height: 32),

                    // 통계 섹션
                    const Text(
                      '어떻게 작동하나요?',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _HowItWorksSection(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BloodOathCard extends StatelessWidget {
  final VoidCallback onTap;
  const _BloodOathCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F25),
          border: Border.all(color: Colors.red.withOpacity(0.6), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              color: Colors.red.withOpacity(0.15),
              child: const Icon(Icons.bloodtype, color: Colors.red, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '피의 서약',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '챌린지 계약을 맺고 보증금을 걸어보세요',
                    style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 16),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F25),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              color: iconColor.withOpacity(0.15),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 14),
          ],
        ),
      ),
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final steps = [
      {'icon': '✍️', 'title': '서약', 'desc': '챌린지를 선택하고 보증금을 설정합니다'},
      {'icon': '🔒', 'title': '잠금', 'desc': '보증금이 스마트 금고에 잠깁니다'},
      {'icon': '📸', 'title': '인증', 'desc': '매일 사진으로 미션을 인증합니다'},
      {'icon': '🏆', 'title': '정산', 'desc': '성공 시 보증금 전액 반환'},
    ];

    return Row(
      children: steps.map((step) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F25),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Column(
                children: [
                  Text(step['icon']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 8),
                  Text(
                    step['title']!,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step['desc']!,
                    style: TextStyle(color: Colors.grey[600], fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
