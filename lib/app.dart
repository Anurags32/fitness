import 'package:flutter/material.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/screens/plan_editor_screen.dart';
import 'ui/screens/plans_list_screen.dart';
import 'ui/screens/workouts_screen.dart';
import 'ui/screens/progress_screen.dart';
import 'ui/screens/profile_screen.dart';
import 'ui/navigation/main_navigation.dart';

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Kolkata',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD1913C)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7F9),
      ),
      routes: {
        '/': (_) => const SplashScreen(),
        SplashScreen.route: (_) => const SplashScreen(),
        MainNavigation.route: (_) => const MainNavigation(),
        PlansListScreen.route: (_) => const PlansListScreen(),
        WorkoutsScreen.route: (_) => const WorkoutsScreen(),
        SeatBookingScreen.route: (_) => const SeatBookingScreen(),
        ProfileScreen.route: (_) => const ProfileScreen(),
        PlanEditorScreen.route: (_) => const PlanEditorScreen(),
      },
    );
  }
}
