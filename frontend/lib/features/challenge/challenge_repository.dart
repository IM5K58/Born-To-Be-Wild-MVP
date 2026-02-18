import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network.dart';
import 'challenge_model.dart';
import '../auth/auth_provider.dart';

final challengeRepositoryProvider = Provider<ChallengeRepository>((ref) {
  return ChallengeRepository(ref.watch(dioProvider));
});

class ChallengeRepository {
  final Dio _dio;

  ChallengeRepository(this._dio);

  Future<Challenge> createChallenge({
    required String userId,
    required String templateId,
    required int amount,
    int? frequencyPerWeek,
    int? durationDays,
  }) async {
    final response = await _dio.post('/challenges', data: {
      'user_id': userId,
      'template_id': templateId,
      'amount': amount,
      'frequency_per_week': frequencyPerWeek ?? 7,
      // 'duration_days': durationDays ?? 30, // API might need update if I added this field
    });
    return Challenge.fromJson(response.data);
  }

  Future<Challenge> activateChallenge(String challengeId, int amount) async {
    final response = await _dio.post('/challenges/$challengeId/activate', data: {
      'amount': amount,
    });
    return Challenge.fromJson(response.data);
  }
}

final createChallengeProvider = StateNotifierProvider<CreateChallengeNotifier, AsyncValue<Challenge?>>((ref) {
  return CreateChallengeNotifier(ref.watch(challengeRepositoryProvider), ref);
});

class CreateChallengeNotifier extends StateNotifier<AsyncValue<Challenge?>> {
  final ChallengeRepository _repository;
  final Ref _ref;

  CreateChallengeNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> createAndActivate({
    required String templateId,
    required int amount,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(authStateProvider).value;
      if (user == null) throw Exception('User not logged in');

      // 1. Create Draft
      final draft = await _repository.createChallenge(
        userId: user.id,
        templateId: templateId,
        amount: amount,
      );

      // 2. Mock Payment & Activate
      // In real app, PG flow here
      final active = await _repository.activateChallenge(draft.id, amount);
      
      state = AsyncValue.data(active);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
