import 'package:flutter/material.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/views/home_screen.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/first_signup_screen.dart';
import 'package:frontend/views/second_signup_screen.dart';
import 'package:frontend/views/start_screen.dart';
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
    path: '/signup',
    name: 'signup',
    builder: (context, state) => SignupScreen(),
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
    path: '/home',
    name: 'home',
    builder: (context, state) => HomeScreen(),
  ),
]);
