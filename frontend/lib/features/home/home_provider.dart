import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network.dart';
import '../challenge/challenge_model.dart';
import '../mission/mission_model.dart';
import '../attempt/attempt_model.dart';
import '../auth/auth_provider.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(ref.watch(dioProvider));
});

class HomeRepository {
  final Dio _dio;

  HomeRepository(this._dio);

  /// 유저의 전체 챌린지 목록 조회
  Future<List<Challenge>> getAllChallenges(String userId) async {
    try {
      final response = await _dio.get('/challenges', queryParameters: {'user_id': userId});
      return (response.data as List)
          .map((e) => Challenge.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 가장 최근 ACTIVE(또는 DRAFT) 챌린지 1개
  Future<Challenge?> getActiveChallenge(String userId) async {
    try {
      final list = await getAllChallenges(userId);
      try {
        return list.firstWhere((c) => c.status == 'ACTIVE',
            orElse: () => list.firstWhere((c) => c.status == 'DRAFT'));
      } catch (_) {
        return null;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    } catch (_) {
      return null;
    }
  }

  Future<Mission?> getTodayMission(String challengeId) async {
    try {
      final response = await _dio.get('/missions/today',
          queryParameters: {'challenge_id': challengeId});
      return Mission.fromJson(response.data);
    } catch (_) {
      return null;
    }
  }

  Future<Attempt?> getTodayAttempt(String userId, String challengeId) async {
    try {
      final response = await _dio.get('/attempts', queryParameters: {'user_id': userId});
      final list = (response.data as List).map((e) => Attempt.fromJson(e)).toList();
      final today = DateTime.now().toIso8601String().split('T')[0];
      try {
        return list.firstWhere(
            (a) => a.challengeId == challengeId && a.submittedAt.startsWith(today));
      } catch (_) {
        return null;
      }
    } catch (_) {
      return null;
    }
  }
}

// ── 대시보드용: 가장 최근 ACTIVE 챌린지 1개 + 미션/인증 ──────────
final homeDataProvider = FutureProvider.autoDispose<HomeData>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) throw Exception('User not logged in');

  final repo = ref.watch(homeRepositoryProvider);
  final challenge = await repo.getActiveChallenge(user.id);

  if (challenge == null) {
    return HomeData(challenge: null, mission: null, attempt: null);
  }

  Mission? mission;
  if (challenge.status == 'ACTIVE') {
    mission = await repo.getTodayMission(challenge.id);
  }

  Attempt? attempt;
  if (mission != null) {
    attempt = await repo.getTodayAttempt(user.id, challenge.id);
  }

  return HomeData(challenge: challenge, mission: mission, attempt: attempt);
});

// ── 피의 서약용: 전체 챌린지 목록 + 각각의 미션/인증 ─────────────
final allChallengesProvider =
    FutureProvider.autoDispose<List<ChallengeDetail>>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return [];

  final repo = ref.watch(homeRepositoryProvider);
  final challenges = await repo.getAllChallenges(user.id);

  final details = await Future.wait(challenges.map((c) async {
    Mission? mission;
    Attempt? attempt;
    if (c.status == 'ACTIVE') {
      mission = await repo.getTodayMission(c.id);
      if (mission != null) {
        attempt = await repo.getTodayAttempt(user.id, c.id);
      }
    }
    return ChallengeDetail(challenge: c, mission: mission, attempt: attempt);
  }));

  return details;
});

// ── 데이터 클래스 ─────────────────────────────────────────────────
class HomeData {
  final Challenge? challenge;
  final Mission? mission;
  final Attempt? attempt;

  HomeData({this.challenge, this.mission, this.attempt});
}

class ChallengeDetail {
  final Challenge challenge;
  final Mission? mission;
  final Attempt? attempt;

  ChallengeDetail({required this.challenge, this.mission, this.attempt});
}
