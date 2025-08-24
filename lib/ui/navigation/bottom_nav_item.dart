import 'package:flutter/material.dart';

class BottomNavItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final Widget screen;
  final Color? color;

  const BottomNavItem({
    required this.label,
    required this.icon,
    required this.screen,
    this.activeIcon,
    this.color,
  });
}

enum NavTab { home, workouts, progress, profile }

extension NavTabExtension on NavTab {
  String get label {
    switch (this) {
      case NavTab.home:
        return 'Home';
      case NavTab.workouts:
        return 'Workouts';
      case NavTab.progress:
        return 'Progress';
      case NavTab.profile:
        return 'Profile';
    }
  }

  IconData get icon {
    switch (this) {
      case NavTab.home:
        return Icons.home_outlined;
      case NavTab.workouts:
        return Icons.fitness_center_outlined;
      case NavTab.progress:
        return Icons.trending_up_outlined;
      case NavTab.profile:
        return Icons.person_outline;
    }
  }

  IconData get activeIcon {
    switch (this) {
      case NavTab.home:
        return Icons.home;
      case NavTab.workouts:
        return Icons.fitness_center;
      case NavTab.progress:
        return Icons.trending_up;
      case NavTab.profile:
        return Icons.person;
    }
  }
}
