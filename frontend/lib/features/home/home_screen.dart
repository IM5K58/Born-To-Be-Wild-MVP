import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'home_provider.dart';
import '../auth/auth_provider.dart';
import '../challenge/challenge_model.dart';
import '../mission/mission_model.dart';
import '../attempt/attempt_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(homeDataProvider);
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text('비스트 하트: ${user?.nickname ?? ""}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: '로그아웃',
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
              context.go('/auth');
            },
          ),
        ],
      ),
      body: homeDataAsync.when(
        data: (data) {
          if (data.challenge == null) {
            return _buildEmptyState(context);
          }
          return _buildDashboard(context, data);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('오류: $err')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.fitness_center, size: 64, color: Colors.grey),
          const SizedBox(height: 20),
          const Text('진행 중인 챌린지가 없습니다', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          const Text('새 챌린지를 시작하고 보증금을 걸어보세요', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('챌린지 시작하기'),
            onPressed: () => context.push('/challenge/create'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, HomeData data) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildChallengeCard(data.challenge!),
        const SizedBox(height: 20),
        _buildMissionCard(context, data.mission, data.attempt),
        const SizedBox(height: 20),
        _buildDepositVault(data.challenge!),
      ],
    );
  }

  Widget _buildChallengeCard(Challenge challenge) {
    final templateNames = {
      'wakeup': '🌅 기상 챌린지',
      'commit': '💻 커밋 챌린지',
      'gym': '🏋️ 헬스 챌린지',
      'study': '📚 공부 챌린지',
      'running': '🏃 러닝 챌린지',
    };
    final name = templateNames[challenge.templateId] ?? challenge.templateId.toUpperCase();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('진행 중인 챌린지', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            const SizedBox(height: 5),
            Text(
              name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    challenge.status == 'ACTIVE' ? '진행 중' : challenge.status,
                    style: const TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ),
                if (challenge.endAt != null) ...[
                  const SizedBox(width: 10),
                  Text('종료일: ${challenge.endAt}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionCard(BuildContext context, Mission? mission, Attempt? attempt) {
    if (mission == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.hourglass_empty, color: Colors.grey),
              SizedBox(height: 8),
              Text('오늘의 미션이 아직 생성되지 않았습니다.'),
            ],
          ),
        ),
      );
    }

    bool isCompleted = attempt != null && attempt.status == 'PASS';
    bool isPending = attempt != null && (attempt.status == 'SUBMITTED' || attempt.status == 'PENDING');
    bool isFailed = attempt != null && attempt.status == 'FAIL';

    return Card(
      color: isCompleted
          ? Colors.green.withOpacity(0.1)
          : (isFailed ? Colors.red.withOpacity(0.1) : null),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('오늘의 미션', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
            const SizedBox(height: 10),
            Text(
              mission.overlayText,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '인증 코드: ${mission.codeword}',
              style: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.w900, color: Colors.amber),
            ),
            const SizedBox(height: 20),
            if (isCompleted)
              const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 10),
                  Text('미션 완료!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              )
            else if (isFailed)
              const Row(
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 10),
                  Text('미션 실패', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              )
            else if (isPending)
              const Row(
                children: [
                  Icon(Icons.hourglass_empty, color: Colors.orange),
                  SizedBox(width: 10),
                  Text('판정 대기 중...', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('미션 인증하기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    context.push('/camera', extra: mission);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepositVault(Challenge challenge) {
    final deposit = challenge.deposit;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('💰 보증금 금고', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (deposit != null) ...[
              Text(
                '${deposit.amount} 원',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.cyan),
              ),
              const SizedBox(height: 5),
              Text(
                deposit.status == 'LOCKED' ? '🔒 잠금 상태' : deposit.status,
                style: const TextStyle(color: Colors.grey),
              ),
            ] else
              const Text('보증금 정보 없음'),
          ],
        ),
      ),
    );
  }
}
