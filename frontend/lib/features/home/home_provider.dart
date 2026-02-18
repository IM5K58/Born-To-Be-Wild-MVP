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

  Future<Challenge?> getActiveChallenge(String userId) async {
    try {
      final response = await _dio.get('/challenges', queryParameters: {'user_id': userId});
      // The API returns a list. Find the first ACTIVE one.
      final list = (response.data as List).map((e) => Challenge.fromJson(e as Map<String, dynamic>)).toList();
      try {
        return list.firstWhere((c) => c.status == 'ACTIVE', orElse: () => list.firstWhere((c) => c.status == 'DRAFT'));
      } catch (e) {
        return null;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    } catch (e) {
      return null;
    }
  }

  Future<Mission?> getTodayMission(String challengeId) async {
    try {
      final response = await _dio.get('/missions/today', queryParameters: {'challenge_id': challengeId});
      return Mission.fromJson(response.data);
    } catch (e) {
       // If 404, maybe no mission generated yet
       return null;
    }
  }

  Future<Attempt?> getTodayAttempt(String userId, String challengeId) async {
     try {
      final response = await _dio.get('/attempts', queryParameters: {'user_id': userId});
      final list = (response.data as List).map((e) => Attempt.fromJson(e)).toList();
      
      // Filter by challengeId and submittedAt (today) strictly
      // But for MVP, let's just find the latest one for this challenge
      final today = DateTime.now().toIso8601String().split('T')[0];
      
      try {
        return list.firstWhere((a) => a.challengeId == challengeId && a.submittedAt.startsWith(today));
      } catch (e) {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

final homeDataProvider = FutureProvider.autoDispose<HomeData>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) throw Exception('User not logged in');

  final repo = ref.watch(homeRepositoryProvider);
  
  final challenge = await repo.getActiveChallenge(user.id);
  
  if (challenge == null) {
    return HomeData(challenge: null, mission: null, attempt: null);
  }

  // If challenge exists, get today's mission
  Mission? mission;
  if (challenge.status == 'ACTIVE') {
    mission = await repo.getTodayMission(challenge.id);
  }

  // If mission exists, check attempt
  Attempt? attempt;
  if (mission != null) {
    attempt = await repo.getTodayAttempt(user.id, challenge.id);
  }

  return HomeData(challenge: challenge, mission: mission, attempt: attempt);
});

class HomeData {
  final Challenge? challenge;
  final Mission? mission;
  final Attempt? attempt;

  HomeData({this.challenge, this.mission, this.attempt});
}
