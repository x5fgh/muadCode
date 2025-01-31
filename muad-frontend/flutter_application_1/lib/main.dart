import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/course_provider.dart';
import 'Screen/AmbassadorsScreen.dart';
import 'Screen/AttendanceTrackerScreen.dart';
import 'Screen/GPACalculatorScreen.dart';
import 'Screen/HomeScreen.dart';
import 'Screen/LoginScreen.dart';
import 'Screen/ProfileScreen.dart';
import 'Screen/ScheduleScreen.dart';
import 'Screen/SignUpScreen.dart';
import 'Screen/UserProvider.dart';
import 'Screen/WelcomScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CourseProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Muad App',
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/schedule': (context) => const ScheduleScreen(),
        '/attendance': (context) => AttendanceTrackerScreen(),
        '/ambassadors': (context) => const AmbassadorsScreen(),
        '/GPACalculator': (context) => const GPACalculatorScreen(),
      },
    );
  }
}
