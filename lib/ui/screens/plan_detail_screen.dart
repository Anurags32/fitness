import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/plan.dart';
import '../widgets/animated_card.dart';
import '../widgets/enhanced_button.dart';

class PlanDetailScreen extends StatefulWidget {
  static const route = '/plan-detail';
  final Plan plan;

  const PlanDetailScreen({super.key, required this.plan});

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen>
    with TickerProviderStateMixin {
  Timer? _timer;
  Duration _remainingTime = Duration.zero;
  bool _isTimerRunning = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _calculateRemainingTime() {
    final now = DateTime.now();
    final timeRange = widget.plan.time.split('-');

    if (timeRange.length == 2) {
      final startTimeParts = timeRange[0].trim().split(':');
      if (startTimeParts.length == 2) {
        final startHour = int.tryParse(startTimeParts[0]) ?? 0;
        final startMinute = int.tryParse(startTimeParts[1]) ?? 0;

        final planStartTime = DateTime(
          now.year,
          now.month,
          now.day,
          startHour,
          startMinute,
        );

        if (planStartTime.isAfter(now)) {
          _remainingTime = planStartTime.difference(now);
        }
      }
    }
  }

  void _startTimer() {
    if (_remainingTime.inSeconds > 0) {
      setState(() {
        _isTimerRunning = true;
      });

      _pulseController.repeat(reverse: true);

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingTime.inSeconds > 0) {
            _remainingTime = _remainingTime - const Duration(seconds: 1);
          } else {
            _stopTimer();
            _showPlanStartedDialog();
          }
        });
      });
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _pulseController.stop();
    setState(() {
      _isTimerRunning = false;
    });
  }

  void _showPlanStartedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Time to Start!'),
        content: Text('Your ${widget.plan.title} session is starting now!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  String get _imageUrl {
    final fitnessSeeds = [
      'fitness-${widget.plan.title.toLowerCase().replaceAll(' ', '-')}',
      'workout-${widget.plan.level.toLowerCase()}',
      'gym-${widget.plan.room.toLowerCase()}',
      'exercise-${widget.plan.trainer.toLowerCase().replaceAll(' ', '-')}',
    ];

    final seedIndex = widget.plan.title.hashCode.abs() % fitnessSeeds.length;
    final seed = fitnessSeeds[seedIndex];

    return 'https://picsum.photos/seed/$seed/800/400';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPadding(
            padding: context.responsivePadding,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildPlanInfo(),
                const SizedBox(height: 24),
                _buildTimerSection(),
                const SizedBox(height: 24),
                _buildDetailsSection(),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.plan.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 3,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              _imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: const Center(
                    child: Icon(
                      Icons.fitness_center,
                      size: 64,
                      color: Colors.white70,
                    ),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanInfo() {
    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.plan.level,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.access_time, 'Time', widget.plan.time),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.room, 'Room', widget.plan.room),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.person, 'Trainer', widget.plan.trainer),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildTimerSection() {
    if (_remainingTime.inSeconds <= 0 && !_isTimerRunning) {
      return AnimatedCard(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        child: Column(
          children: [
            Icon(
              Icons.check_circle,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Session Time!',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Your fitness session is ready to start',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isTimerRunning ? _pulseAnimation.value : 1.0,
          child: AnimatedCard(
            backgroundColor: _isTimerRunning
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
            child: Column(
              children: [
                Icon(
                  Icons.timer,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  _formatDuration(_remainingTime),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isTimerRunning
                      ? 'Until your session starts'
                      : 'Time remaining',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                EnhancedButton(
                  label: _isTimerRunning ? 'Stop Timer' : 'Start Timer',
                  icon: _isTimerRunning ? Icons.stop : Icons.play_arrow,
                  onPressed: _isTimerRunning ? _stopTimer : _startTimer,
                  backgroundColor: _isTimerRunning
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailsSection() {
    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Session Details',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Get ready for an amazing ${widget.plan.level.toLowerCase()} level fitness session! '
            'Your trainer ${widget.plan.trainer} will guide you through the workout in ${widget.plan.room}.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          const Text(
            '💪 Tips for your session:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text('• Arrive 5 minutes early'),
          const Text('• Bring a water bottle'),
          const Text('• Wear comfortable workout clothes'),
          const Text('• Listen to your trainer\'s instructions'),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
       
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session marked as completed! 🎉')),
        );
      },
      icon: const Icon(Icons.check),
      label: const Text('Complete Session'),
    );
  }
}
