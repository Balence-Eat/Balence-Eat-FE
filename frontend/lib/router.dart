import 'package:frontend/model/user.dart';
import 'package:frontend/view/analysis_screen/analysis_page.dart';
import 'package:frontend/view/home-screen/add_meal_screen.dart';
import 'package:frontend/view/home-screen/home_screen.dart';
import 'package:frontend/view/login-signup/first_signup_screen.dart';
import 'package:frontend/view/login-signup/login.dart';
import 'package:frontend/view/login-signup/second_signup_screen.dart';
import 'package:frontend/view/login-signup/start_screen.dart';
import 'package:frontend/view/my_%20refrigerator/my_refreigerator.dart';
import 'package:frontend/view/my_info/edit_profile_screen.dart';
import 'package:frontend/view/my_info/profile_login.dart';
import 'package:frontend/view/my_info/profile_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    name: 'start',
    builder: (context, state) => StartScreen(),
  ),
  GoRoute(
    path: '/login',
    name: 'login',
    builder: (context, state) => LoginScreen(),
  ),
  GoRoute(
    path: '/first-signup',
    name: 'first-signup',
    builder: (context, state) => FirstSignupScreen(),
  ),
  GoRoute(
    path: '/second_signup',
    name: 'second_signup',
    builder: (context, state) {
      final user = state.extra as User;
      return SecondSignupScreen(partialUser: user);
    },
  ),
  GoRoute(
    path: '/refrigerator',
    name: 'refriegerator',
    builder: (context, state) => RefrigeratorScreen(),
  ),
  GoRoute(
    path: '/home',
    name: 'home',
    builder: (context, state) => HomeScreen(),
  ),
  GoRoute(
    path: '/add-meal',
    name: 'add-meal',
    builder: (context, state) => AddMealScreen(),
  ),
  GoRoute(
    path: '/analysis',
    name: 'analysis',
    builder: (context, state) => AnalysisPage(),
  ),
  GoRoute(
    path: '/my',
    name: 'my',
    builder: (context, state) => const ProfileLogin(),
  ),
  GoRoute(
    path: '/profile/detail',
    name: 'profile',
    builder: (context, state) => const ProfileScreen(),
  ),
  GoRoute(
    path: '/edit-profile',
    name: 'edit-profile',
    builder: (context, state) => EditProfileScreen(),
  ),
]);
