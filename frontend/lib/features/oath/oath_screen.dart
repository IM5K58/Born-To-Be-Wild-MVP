import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_provider.dart';
import '../home/home_provider.dart';
import '../challenge/challenge_model.dart';
import '../mission/mission_model.dart';
import '../attempt/attempt_model.dart';

class OathScreen extends ConsumerWidget {
  const OathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAsync = ref.watch(allChallengesProvider);
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14),
        title: const Text(
          '피의 서약',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add, color: Colors.red, size: 18),
            label: const Text('새 서약', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              await context.push('/challenge/create');
              ref.refresh(allChallengesProvider); // 생성 후 목록 갱신
            },
          ),
        ],
      ),
      body: allAsync.when(
        data: (details) => _buildBody(context, ref, details, user),
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.red)),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('오류: $err', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, List<ChallengeDetail> details, user) {
    return Column(
      children: [
        // 상단 배너
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.red.withOpacity(0.3))),
          ),
          child: Row(
            children: [
              const Icon(Icons.bloodtype, color: Colors.red, size: 18),
              const SizedBox(width: 8),
              Text(
                '${user?.nickname ?? ""}의 서약서',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  border: Border.all(color: Colors.red.withOpacity(0.4), width: 0.5),
                ),
                child: Text(
                  '총 ${details.length}건',
                  style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: details.isEmpty
              ? _buildEmptyOath(context)
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: details.length + 1, // +1 for "새 서약" button at bottom
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == details.length) {
                      return _buildAddButton(context);
                    }
                    return _ContractCard(detail: details[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyOath(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red.withOpacity(0.3), width: 2),
            ),
            child: const Icon(Icons.bloodtype_outlined, color: Colors.red, size: 48),
          ),
          const SizedBox(height: 24),
          const Text(
            '아직 서약이 없습니다',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text('첫 번째 피의 서약을 맺어보세요', style: TextStyle(color: Colors.grey[500])),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('서약 맺기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            onPressed: () => context.push('/challenge/create'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.add, color: Colors.red),
      label: const Text('새 서약 추가', style: TextStyle(color: Colors.red)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.red),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onPressed: () => context.push('/challenge/create'),
    );
  }
}

// ── 개별 계약서 카드 ──────────────────────────────────────────────
class _ContractCard extends ConsumerWidget {
  final ChallengeDetail detail;
  const _ContractCard({required this.detail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenge = detail.challenge;
    final deposit = challenge.deposit;
    final mission = detail.mission;
    final attempt = detail.attempt;

    final templateNames = {
      'wakeup': '🌅 기상 챌린지',
      'commit': '💻 커밋 챌린지',
      'gym': '🏋️ 헬스 챌린지',
      'study': '📚 공부 챌린지',
      'running': '🏃 러닝 챌린지',
    };

    final failureRuleLabels = {
      'BURN': '🔥 완전 소각',
      'CREDIT': '💎 크레딧 전환',
      'DONATE': '🤝 기부',
    };

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F25),
        border: Border.all(
          color: challenge.status == 'ACTIVE'
              ? Colors.red.withOpacity(0.4)
              : Colors.white.withOpacity(0.08),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // 카드 헤더
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: challenge.status == 'ACTIVE'
                ? Colors.red.withOpacity(0.08)
                : Colors.white.withOpacity(0.03),
            child: Row(
              children: [
                const Icon(Icons.article, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Text(
                  templateNames[challenge.templateId] ?? challenge.templateId,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                _StatusBadge(status: challenge.status),
              ],
            ),
          ),

          // 계약 내용
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _Row('시작일', challenge.startAt ?? '-'),
                const Divider(color: Colors.white12, height: 20),
                _Row('종료일', challenge.endAt ?? '-'),
                const Divider(color: Colors.white12, height: 20),
                _Row(
                  '보증금',
                  deposit != null ? '${deposit.amount} 원' : '-',
                  valueColor: Colors.cyan,
                ),
                const Divider(color: Colors.white12, height: 20),
                _Row(
                  '보증금 상태',
                  deposit?.status == 'LOCKED' ? '🔒 잠금' : (deposit?.status ?? '-'),
                  valueColor: Colors.amber,
                ),
                const Divider(color: Colors.white12, height: 20),
                _Row(
                  '실패 패널티',
                  failureRuleLabels[challenge.failureRule] ?? '🔥 완전 소각',
                  valueColor: Colors.red,
                ),
              ],
            ),
          ),

          // 오늘의 미션 (ACTIVE 챌린지만)
          if (challenge.status == 'ACTIVE')
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
              ),
              child: mission == null
                  ? Text(
                      '오늘의 미션이 아직 생성되지 않았습니다.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '오늘의 미션',
                          style: TextStyle(color: Colors.grey, fontSize: 11, letterSpacing: 1),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          mission.overlayText,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        if (attempt == null)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.camera_alt, size: 16),
                              label: const Text('지금 인증하기'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              onPressed: () => context.push('/camera', extra: mission),
                            ),
                          )
                        else
                          _AttemptStatus(status: attempt.status),
                      ],
                    ),
            ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _Row(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final configs = {
      'ACTIVE': (Colors.green, '진행 중'),
      'DRAFT': (Colors.blue, '준비 중'),
      'COMPLETED': (Colors.cyan, '완료'),
      'FAILED': (Colors.red, '실패'),
      'CANCELLED': (Colors.grey, '취소'),
    };
    final config = configs[status] ?? (Colors.grey, status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: config.$1.withOpacity(0.15),
        border: Border.all(color: config.$1, width: 0.5),
      ),
      child: Text(
        config.$2,
        style: TextStyle(color: config.$1, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _AttemptStatus extends StatelessWidget {
  final String status;
  const _AttemptStatus({required this.status});

  @override
  Widget build(BuildContext context) {
    final configs = {
      'PASS': (Icons.check_circle, Colors.green, '미션 완료! 🎉'),
      'FAIL': (Icons.cancel, Colors.red, '미션 실패'),
      'SUBMITTED': (Icons.hourglass_top, Colors.orange, '판정 대기 중...'),
      'PENDING': (Icons.hourglass_top, Colors.orange, '판정 대기 중...'),
    };
    final config = configs[status] ?? (Icons.help_outline, Colors.grey, status);

    return Row(
      children: [
        Icon(config.$1, color: config.$2, size: 16),
        const SizedBox(width: 6),
        Text(config.$3, style: TextStyle(color: config.$2, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}
