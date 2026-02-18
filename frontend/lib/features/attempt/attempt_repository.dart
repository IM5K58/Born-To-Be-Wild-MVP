import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/network.dart';
import 'attempt_model.dart';
import '../auth/auth_provider.dart';

final attemptRepositoryProvider = Provider<AttemptRepository>((ref) {
  return AttemptRepository(ref.watch(dioProvider));
});

class AttemptRepository {
  final Dio _dio;

  AttemptRepository(this._dio);

  Future<Attempt> submitProofXFile({
    required String challengeId,
    required String missionId,
    required String userId,
    required XFile file,
  }) async {
    MultipartFile multipartFile;
    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      multipartFile = MultipartFile.fromBytes(bytes, filename: file.name);
    } else {
      multipartFile = await MultipartFile.fromFile(file.path, filename: file.name);
    }

    final formData = FormData.fromMap({
      'file': multipartFile,
      'challenge_id': challengeId,
      'mission_id': missionId,
      'user_id': userId,
    });

    final response = await _dio.post('/attempts', data: formData);
    return Attempt.fromJson(response.data);
  }
}

final submitAttemptProvider = StateNotifierProvider<SubmitAttemptNotifier, AsyncValue<Attempt?>>((ref) {
  return SubmitAttemptNotifier(ref.watch(attemptRepositoryProvider), ref);
});

class SubmitAttemptNotifier extends StateNotifier<AsyncValue<Attempt?>> {
  final AttemptRepository _repository;
  final Ref _ref;

  SubmitAttemptNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> submitXFile({
    required String challengeId,
    required String missionId,
    required XFile file,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(authStateProvider).value;
      if (user == null) throw Exception('User not logged in');

      final attempt = await _repository.submitProofXFile(
        challengeId: challengeId,
        missionId: missionId,
        userId: user.id,
        file: file,
      );

      state = AsyncValue.data(attempt);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
