import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'home_provider.dart';
import '../auth/auth_provider.dart';
import '../mission/mission_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAsync = ref.watch(allChallengesProvider);
    final user = ref.watch(authStateProvider).value;
    const primaryColor = Color(0xFFCE4257);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14),
        title: const Text(
          '오늘의 챌린지 현황',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.grey),
            tooltip: '로그아웃',
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
              context.go('/auth');
            },
          ),
        ],
      ),
      body: allAsync.when(
        data: (details) {
          // ACTIVE 챌린지 중 오늘 아직 인증하지 않은 것만 필터링
          final pendingToday = details.where((d) {
            if (d.challenge.status != 'ACTIVE') return false;
            if (d.mission == null) return false; // 미션 없으면 제외
            // 인증 안 했거나 실패한 경우
            final attempt = d.attempt;
            if (attempt == null) return true;
            return attempt.status == 'FAIL';
          }).toList();

          return _buildBody(context, ref, details, pendingToday, user);
        },
        loading: () => const Center(child: CircularProgressIndicator(color: primaryColor)),
        error: (err, _) => Center(
          child: Text('오류: $err', style: const TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, List<ChallengeDetail> all, List<ChallengeDetail> pending, user) {
    final today = DateTime.now();
    final dateStr = '${today.year}년 ${today.month}월 ${today.day}일';

    return Column(
      children: [
        // 날짜 헤더
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.06))),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.cyan, size: 16),
              const SizedBox(width: 8),
              Text(dateStr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const Spacer(),
              // 요약 뱃지
              _SummaryBadge(
                pending: pending.length,
                total: all.where((d) => d.challenge.status == 'ACTIVE' && d.mission != null).length,
              ),
            ],
          ),
        ),

        Expanded(
          child: pending.isEmpty
              ? _buildAllDoneState(context, all)
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: pending.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => _TodayMissionCard(detail: pending[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildAllDoneState(BuildContext context, List<ChallengeDetail> all) {
    const primaryColor = Color(0xFFCE4257);
    final hasActive = all.any((d) => d.challenge.status == 'ACTIVE');

    if (!hasActive) {
      // 진행 중인 챌린지 자체가 없음
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center, size: 64, color: Colors.grey),
            const SizedBox(height: 20),
            const Text('진행 중인 챌린지가 없습니다',
                style: TextStyle(fontSize: 18, color: Colors.white)),
            const SizedBox(height: 8),
            Text('피의 서약을 맺고 보증금을 걸어보세요',
                style: TextStyle(color: Colors.grey[500])),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.bloodtype),
              label: const Text('서약 맺기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              onPressed: () => context.push('/challenge/create'),
            ),
          ],
        ),
      );
    }

    // 모든 미션 완료!
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(0.1),
              border: Border.all(color: Colors.green.withOpacity(0.4), width: 2),
            ),
            child: const Icon(Icons.check_circle_outline, color: Colors.green, size: 52),
          ),
          const SizedBox(height: 24),
          const Text(
            '오늘 모든 미션 완료! 🎉',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text('대단해요! 오늘도 야수의 심장으로 버텼습니다',
              style: TextStyle(color: Colors.grey[500])),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            icon: const Icon(Icons.article_outlined, color: primaryColor),
            label: const Text('서약 목록 보기', style: TextStyle(color: primaryColor)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: primaryColor)),
            onPressed: () => context.push('/oath'),
          ),
        ],
      ),
    );
  }
}

// ── 오늘 미인증 챌린지 카드 ────────────────────────────────────────
class _TodayMissionCard extends StatelessWidget {
  final ChallengeDetail detail;
  const _TodayMissionCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    final challenge = detail.challenge;
    final mission = detail.mission!;
    final attempt = detail.attempt;
    final isFailed = attempt?.status == 'FAIL';
    
    const primaryColor = Color(0xFFCE4257);
    const orangeColor = Color(0xFFE07A5F);

    final templateNames = {
      'wakeup': '🌅 기상 챌린지',
      'commit': '💻 커밋 챌린지',
      'gym': '🏋️ 헬스 챌린지',
      'study': '📚 공부 챌린지',
      'running': '🏃 러닝 챌린지',
    };

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F25),
        border: Border.all(
          color: isFailed ? primaryColor.withOpacity(0.5) : orangeColor.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // 카드 헤더
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: isFailed
                ? primaryColor.withOpacity(0.08)
                : orangeColor.withOpacity(0.06),
            child: Row(
              children: [
                Icon(
                  isFailed ? Icons.warning_amber : Icons.pending_actions,
                  color: isFailed ? primaryColor : orangeColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  templateNames[challenge.templateId] ?? challenge.templateId,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (isFailed ? primaryColor : orangeColor).withOpacity(0.15),
                    border: Border.all(
                      color: isFailed ? primaryColor : orangeColor,
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    isFailed ? '재인증 필요' : '미인증',
                    style: TextStyle(
                      color: isFailed ? primaryColor : orangeColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 미션 내용
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '오늘의 미션',
                  style: TextStyle(color: Colors.grey[600], fontSize: 11, letterSpacing: 1),
                ),
                const SizedBox(height: 6),
                Text(
                  mission.overlayText,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.vpn_key, color: Colors.amber, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '인증 코드: ${mission.codeword}',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt, size: 16),
                    label: Text(isFailed ? '다시 인증하기' : '지금 인증하기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFailed ? orangeColor : primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => context.push('/camera', extra: mission),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── 요약 뱃지 ─────────────────────────────────────────────────────
class _SummaryBadge extends StatelessWidget {
  final int pending;
  final int total;
  const _SummaryBadge({required this.pending, required this.total});

  @override
  Widget build(BuildContext context) {
    const orangeColor = Color(0xFFE07A5F);
    final done = total - pending;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: orangeColor.withOpacity(0.15),
            border: Border.all(color: orangeColor.withOpacity(0.4), width: 0.5),
          ),
          child: Text(
            '미인증 $pending건',
            style: const TextStyle(color: orangeColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.15),
            border: Border.all(color: Colors.green.withOpacity(0.4), width: 0.5),
          ),
          child: Text(
            '완료 $done/$total',
            style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
