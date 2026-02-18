import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/landing/landing_screen.dart';
import '../features/home/home_screen.dart';
import '../features/auth/auth_screen.dart';
import '../features/challenge/create_challenge_screen.dart';
import '../features/camera/camera_screen.dart';
import '../features/oath/oath_screen.dart';
import '../features/mission/mission_model.dart';
import '../features/auth/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/auth',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isAuthRoute = state.matchedLocation == '/auth';

      // 로그인 안 됐으면 /auth로
      if (!isLoggedIn && !isAuthRoute) return '/auth';
      // 이미 로그인됐으면 /auth에서 메인으로
      if (isLoggedIn && isAuthRoute) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/oath',
        builder: (context, state) => const OathScreen(),
      ),
      GoRoute(
        path: '/challenge/create',
        builder: (context, state) => const CreateChallengeScreen(),
      ),
      GoRoute(
        path: '/camera',
        builder: (context, state) {
          final mission = state.extra as Mission?;
          return CameraScreen(mission: mission);
        },
      ),
    ],
  );
});
