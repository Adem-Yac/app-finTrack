import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiConstants {
  static const String tokenKey = 'fintrack_token';
  static const String onboardingKey = 'fintrack_onboarding_seen';

  static const String hostedUrl =
      'https://fintrack-api-ruddy.vercel.app/api/v1';
  static const String localUrl = 'http://127.0.0.1:8000/api/v1';
  static const String androidEmulatorUrl = 'http://10.0.2.2:8000/api/v1';

  static String get baseUrl {
    const env = String.fromEnvironment('API_URL');
    if (env.isNotEmpty) {
      return env;
    }
    if (kReleaseMode) {
      return hostedUrl;
    }
    if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return localUrl;
    }
    const useLocal = bool.fromEnvironment('USE_LOCAL_API');
    if (useLocal && Platform.isAndroid) {
      return androidEmulatorUrl;
    }
    return hostedUrl;
  }
}
