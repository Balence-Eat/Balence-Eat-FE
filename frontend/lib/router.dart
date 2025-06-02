import 'package:flutter/material.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/views/add_meal.dart';
import 'package:frontend/views/home_screen.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/first_signup_screen.dart';
import 'package:frontend/views/second_signup_screen.dart';
import 'package:frontend/views/start_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/views/analysis_page.dart';
import 'package:frontend/views/profile_login.dart';
import 'package:frontend/views/profile_screen.dart';
import 'package:frontend/views/edit_profile_screen.dart';

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
    builder: (context, state) =>  EditProfileScreen(),
  ),
]);
