import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_provider.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    ref.listen<AsyncValue<dynamic>>(authStateProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        context.go('/');
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: ${next.error}')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('비스트 하트', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('작심삼일을 이겨내는 챌린지', style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 40),
            if (authState.isLoading)
              const CircularProgressIndicator()
            else ...[
              SizedBox(
                width: 280,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.g_mobiledata, size: 24),
                  label: const Text('구글로 시작하기 (테스트)'),
                  onPressed: () {
                    ref.read(authStateProvider.notifier).login(
                      'google',
                      'test-google-id',
                      nickname: '구글유저',
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 280,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.chat_bubble, size: 20),
                  label: const Text('카카오로 시작하기 (테스트)'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFEE500), foregroundColor: Colors.black),
                  onPressed: () {
                    ref.read(authStateProvider.notifier).login(
                      'kakao',
                      'test-kakao-id',
                      nickname: '카카오유저',
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
