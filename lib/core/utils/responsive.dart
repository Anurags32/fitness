import 'package:flutter/material.dart';

class Responsive {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    }
    if (isTablet(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  static EdgeInsets responsivePadding(BuildContext context) {
    return EdgeInsets.all(
      responsive(context, mobile: 16.0, tablet: 24.0, desktop: 32.0),
    );
  }

  static EdgeInsets responsiveMargin(BuildContext context) {
    return EdgeInsets.all(
      responsive(context, mobile: 8.0, tablet: 12.0, desktop: 16.0),
    );
  }

  static double responsiveFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return responsive(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.1,
      desktop: desktop ?? mobile * 1.2,
    );
  }

  static int getGridColumns(BuildContext context) {
    return responsive(context, mobile: 1, tablet: 2, desktop: 3);
  }

  static double getCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return responsive(
      context,
      mobile: screenWidth - 32,
      tablet: (screenWidth - 48) / 2,
      desktop: (screenWidth - 64) / 3,
    );
  }

  static double getMaxContentWidth(BuildContext context) {
    return responsive(
      context,
      mobile: double.infinity,
      tablet: 800,
      desktop: 1200,
    );
  }
}

extension ResponsiveContext on BuildContext {
  bool get isMobile => Responsive.isMobile(this);
  bool get isTablet => Responsive.isTablet(this);
  bool get isDesktop => Responsive.isDesktop(this);

  T responsive<T>({required T mobile, T? tablet, T? desktop}) =>
      Responsive.responsive(
        this,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );

  EdgeInsets get responsivePadding => Responsive.responsivePadding(this);
  EdgeInsets get responsiveMargin => Responsive.responsiveMargin(this);
  int get gridColumns => Responsive.getGridColumns(this);
  double get cardWidth => Responsive.getCardWidth(this);
  double get maxContentWidth => Responsive.getMaxContentWidth(this);
}
