import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

final dioProvider = Provider<Dio>((ref) {
  String baseUrl;
  if (kIsWeb) {
    baseUrl = 'http://localhost:3000';
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    baseUrl = 'http://10.0.2.2:3000';
  } else {
    baseUrl = 'http://localhost:3000'; // iOS / Desktop
  }
  print('Network Config: kIsWeb=$kIsWeb, Platform=$defaultTargetPlatform, BaseUrl=$baseUrl');

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      // baseUrl: 'http://localhost:3000', // iOS Simulator / Web
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));

  return dio;
});
