import 'package:flutter/material.dart';
import 'package:quiz_app/meta/view/authentication/login.view.dart';
import 'package:quiz_app/meta/view/authentication/signup.view.dart';
import '../../main.dart';

import '../../onboardingscreen.dart';

class AppRoutes {
  static const String splashroute = '/splash';
  static const String onboardingroute = '/onboarding';
  static const String signuproute = '/signup';
  static const String loginroute = '/login';

  static Map<String, WidgetBuilder> routes = {
    splashroute: (context) => const SplashScreen(),
    onboardingroute: (context) => const OnboardingScreen(),
    signuproute: (context) => SignUpScreen(),
    loginroute: (context) => LoginView(),
  };
}
