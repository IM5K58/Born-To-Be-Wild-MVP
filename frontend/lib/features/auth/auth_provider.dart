import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network.dart';
import 'user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(dioProvider));
});

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<User> login(String provider, String providerId, {String? nickname}) async {
    try {
      final response = await _dio.post(
        '/users/login',
        data: {
          'provider': provider,
          'provider_id': providerId,
          'nickname': nickname,
        },
      );
      print('Login Response: ${response.data}'); // Debug
      return User.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        print('Login Error: ${e.response?.data}');
      }
      rethrow;
    }
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncValue.data(null)) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('auth_user');
    if (jsonString != null) {
      try {
        final user = User.fromJson(jsonDecode(jsonString));
        state = AsyncValue.data(user);
      } catch (e) {
        state = const AsyncValue.data(null);
      }
    }
  }

  Future<void> login(String provider, String providerId, {String? nickname}) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.login(provider, providerId, nickname: nickname);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_user', jsonEncode(user.toJson()));
      
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_user');
    state = const AsyncValue.data(null);
  }
}
