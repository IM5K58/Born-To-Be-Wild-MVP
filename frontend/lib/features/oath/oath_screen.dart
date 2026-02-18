import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../challenge/challenge_model.dart';
import '../challenge/challenge_repository.dart';
import '../auth/auth_provider.dart';
import '../home/home_provider.dart';

class OathScreen extends ConsumerWidget {
  const OathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(homeDataProvider);
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
            onPressed: () => context.push('/challenge/create'),
          ),
        ],
      ),
      body: homeDataAsync.when(
        data: (data) => _buildBody(context, ref, data, user),
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

  Widget _buildBody(BuildContext context, WidgetRef ref, HomeData data, user) {
    return Column(
      children: [
        // 상단 배너
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.red.withOpacity(0.3))),
          ),
          child: Row(
            children: [
              const Icon(Icons.bloodtype, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                '${user?.nickname ?? ""}의 서약서',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        Expanded(
          child: data.challenge == null
              ? _buildEmptyOath(context)
              : _buildContractList(context, ref, data),
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
          Text(
            '첫 번째 피의 서약을 맺어보세요',
            style: TextStyle(color: Colors.grey[500]),
          ),
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

  Widget _buildContractList(BuildContext context, WidgetRef ref, HomeData data) {
    final challenge = data.challenge!;
    final deposit = challenge.deposit;

    final templateNames = {
      'wakeup': '🌅 기상 챌린지',
      'commit': '💻 커밋 챌린지',
      'gym': '🏋️ 헬스 챌린지',
      'study': '📚 공부 챌린지',
      'running': '🏃 러닝 챌린지',
    };

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // 계약서 카드
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F25),
            border: Border.all(color: Colors.red.withOpacity(0.4), width: 1.5),
          ),
          child: Column(
            children: [
              // 계약서 헤더
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.red.withOpacity(0.1),
                child: Row(
                  children: [
                    const Icon(Icons.article, color: Colors.red, size: 18),
                    const SizedBox(width: 8),
                    const Text(
                      '계약서',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    _StatusBadge(status: challenge.status),
                  ],
                ),
              ),

              // 계약 내용
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _ContractRow(
                      label: '챌린지 종류',
                      value: templateNames[challenge.templateId] ?? challenge.templateId,
                    ),
                    const Divider(color: Colors.white12, height: 24),
                    _ContractRow(
                      label: '시작일',
                      value: challenge.startAt ?? '-',
                    ),
                    const Divider(color: Colors.white12, height: 24),
                    _ContractRow(
                      label: '종료일',
                      value: challenge.endAt ?? '-',
                    ),
                    const Divider(color: Colors.white12, height: 24),
                    _ContractRow(
                      label: '보증금',
                      value: deposit != null ? '${deposit.amount} 원' : '-',
                      valueColor: Colors.cyan,
                    ),
                    const Divider(color: Colors.white12, height: 24),
                    _ContractRow(
                      label: '보증금 상태',
                      value: deposit?.status == 'LOCKED' ? '🔒 잠금' : (deposit?.status ?? '-'),
                      valueColor: Colors.amber,
                    ),
                    const Divider(color: Colors.white12, height: 24),
                    _ContractRow(
                      label: '실패 패널티',
                      value: '보증금 100% 소각 🔥',
                      valueColor: Colors.red,
                    ),
                  ],
                ),
              ),

              // 오늘의 미션 상태
              if (data.mission != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '오늘의 미션',
                        style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data.mission!.overlayText,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const SizedBox(height: 12),
                      if (data.attempt == null)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.camera_alt, size: 18),
                            label: const Text('지금 인증하기'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => context.push('/camera', extra: data.mission),
                          ),
                        )
                      else
                        _AttemptStatusRow(status: data.attempt!.status),
                    ],
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 새 챌린지 추가 버튼
        OutlinedButton.icon(
          icon: const Icon(Icons.add, color: Colors.red),
          label: const Text('새 서약 추가', style: TextStyle(color: Colors.red)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () => context.push('/challenge/create'),
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
    final isActive = status == 'ACTIVE';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
        border: Border.all(color: isActive ? Colors.green : Colors.grey, width: 0.5),
      ),
      child: Text(
        isActive ? '진행 중' : status,
        style: TextStyle(
          color: isActive ? Colors.green : Colors.grey,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ContractRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ContractRow({required this.label, required this.value, this.valueColor});

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

class _AttemptStatusRow extends StatelessWidget {
  final String status;
  const _AttemptStatusRow({required this.status});

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
        Icon(config.$1, color: config.$2, size: 18),
        const SizedBox(width: 8),
        Text(config.$3, style: TextStyle(color: config.$2, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
