import 'package:flutter/material.dart';
import 'package:medicare/screens/Login/login_screen.dart';
import 'package:medicare/screens/Signup/signup_screen.dart';
import 'package:medicare/screens/Welcome/welcome_screen.dart';
import 'package:medicare/screens/doctor_appointement.dart';
import 'package:medicare/screens/doctor_detail.dart';
import 'package:medicare/screens/home.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/login': (context) => LoginScreen(),
  '/signin': (context) => SignUpScreen(),
  '/home': (context) => Home(),
  '/detail': (context) => SliverDoctorDetail(),
  '/welcome': (context) => WelcomeScreen(),
  '/appointment': (context) => DoctorAppointement()
};
