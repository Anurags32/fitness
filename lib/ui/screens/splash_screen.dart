import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';
import '../navigation/main_navigation.dart';

class SplashScreen extends StatefulWidget {
  static const route = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _pulseController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _titleSlideAnimation;
  late Animation<double> _titleOpacityAnimation;
  late Animation<double> _subtitleAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimationSequence();
  }

  void _setupAnimations() {
    
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );
    _titleSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _titleOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeIn),
      ),
    );
    _subtitleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeInOut),
      ),
    );
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_particleController);
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(_pulseController);
  }

  void _startAnimationSequence() async {
    _mainController.forward();
    await Future.delayed(const Duration(milliseconds: 4500));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(MainNavigation.route);
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _mainController,
          _particleController,
          _pulseController,
        ]),
        builder: (context, child) {
          return Container(
            decoration: _buildBackgroundDecoration(),
            child: Stack(
              children: [_buildParticleBackground(), _buildMainContent()],
            ),
          );
        },
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFD1913C), 
          Color(0xFFFFD194), 
          Color(0xFFA86832), 
        ],
        stops: [0.0, 0.5, 1.0],
      ),
    );
  }

  Widget _buildParticleBackground() {
    return CustomPaint(
      painter: ParticlePainter(_particleAnimation.value),
      size: Size.infinite,
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            _buildLogo(),
            const SizedBox(height: 40),
            _buildTitle(),
            const SizedBox(height: 16),
            _buildSubtitle(),
            const Spacer(flex: 2),
            _buildProgressIndicator(),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Transform.scale(
      scale: _logoScaleAnimation.value * _pulseAnimation.value,
      child: Opacity(
        opacity: _logoOpacityAnimation.value,
        child: Container(
          width: context.responsive(
            mobile: 140.0,
            tablet: 160.0,
            desktop: 180.0,
          ),
          height: context.responsive(
            mobile: 140.0,
            tablet: 160.0,
            desktop: 180.0,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Colors.white, Color(0xFFF0F0F0), Color(0xFFE0E0E0)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Icon(
            Icons.fitness_center,
            size: context.responsive(mobile: 70.0, tablet: 80.0, desktop: 90.0),
            color: const Color(0xFF667eea),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Transform.translate(
      offset: Offset(0, _titleSlideAnimation.value),
      child: Opacity(
        opacity: _titleOpacityAnimation.value,
        child: Text(
          'FITNESS KOLKATA',
          style: TextStyle(
            fontSize: Responsive.responsiveFontSize(
              context,
              mobile: 28,
              tablet: 32,
              desktop: 36,
            ),
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2.0,
            shadows: [
              Shadow(
                offset: const Offset(0, 3),
                blurRadius: 6,
                color: Colors.black.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Opacity(
      opacity: _subtitleAnimation.value,
      child: Text(
        'Transform Your Body, Transform Your Life',
        style: TextStyle(
          fontSize: Responsive.responsiveFontSize(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
          fontWeight: FontWeight.w400,
          color: Colors.white.withOpacity(0.9),
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Opacity(
      opacity: _progressAnimation.value,
      child: Column(
        children: [
          Container(
            width: 200,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white.withOpacity(0.3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _progressAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFF0F0F0)],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Preparing your fitness journey...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 50; i++) {
      final x = (size.width * (i * 0.1 + animationValue * 0.5)) % size.width;
      final y = (size.height * (i * 0.07 + animationValue * 0.3)) % size.height;
      final radius = 1.0 + (i % 3);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
