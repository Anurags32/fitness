import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/plan.dart';
import 'animated_card.dart';

class PlanCard extends StatelessWidget {
  final Plan plan;
  final VoidCallback? onTap;
  const PlanCard({super.key, required this.plan, this.onTap});

  String get _imageUrl {
    final fitnessImages = [
      "https://images.pexels.com/photos/1552249/pexels-photo-1552249.jpeg",
      "https://images.pexels.com/photos/841130/pexels-photo-841130.jpeg",
      "https://images.pexels.com/photos/1954524/pexels-photo-1954524.jpeg",
      "https://images.pexels.com/photos/416778/pexels-photo-416778.jpeg",
      "https://images.pexels.com/photos/2261485/pexels-photo-2261485.jpeg",
      "https://images.pexels.com/photos/325349/pexels-photo-325349.jpeg",
      "https://images.pexels.com/photos/1552106/pexels-photo-1552106.jpeg",
      "https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg",
      "https://images.pexels.com/photos/1552108/pexels-photo-1552108.jpeg",
      "https://images.pexels.com/photos/4761791/pexels-photo-4761791.jpeg",
      "https://images.pexels.com/photos/1552252/pexels-photo-1552252.jpeg",
      "https://images.pexels.com/photos/2261477/pexels-photo-2261477.jpeg",
      "https://images.pexels.com/photos/260352/pexels-photo-260352.jpeg",
      "https://images.pexels.com/photos/7672258/pexels-photo-7672258.jpeg",
      "https://images.pexels.com/photos/4754137/pexels-photo-4754137.jpeg",
      "https://images.pexels.com/photos/416747/pexels-photo-416747.jpeg",
      "https://images.pexels.com/photos/414029/pexels-photo-414029.jpeg",
      "https://images.pexels.com/photos/841131/pexels-photo-841131.jpeg",
      "https://images.pexels.com/photos/1552109/pexels-photo-1552109.jpeg",
      "https://images.pexels.com/photos/1552248/pexels-photo-1552248.jpeg",
      "https://images.pexels.com/photos/2475878/pexels-photo-2475878.jpeg",
      "https://images.pexels.com/photos/3838389/pexels-photo-3838389.jpeg",
      "https://images.pexels.com/photos/3839149/pexels-photo-3839149.jpeg",
      "https://images.pexels.com/photos/1552107/pexels-photo-1552107.jpeg",
      "https://images.pexels.com/photos/5214995/pexels-photo-5214995.jpeg",
      "https://images.pexels.com/photos/3912944/pexels-photo-3912944.jpeg",
      "https://images.pexels.com/photos/4752865/pexels-photo-4752865.jpeg",
      "https://images.pexels.com/photos/6454135/pexels-photo-6454135.jpeg",
      "https://images.pexels.com/photos/6454133/pexels-photo-6454133.jpeg",
      "https://images.pexels.com/photos/6454131/pexels-photo-6454131.jpeg",
    ];

    final index = plan.title.hashCode.abs() % fitnessImages.length;
    return fitnessImages[index];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      onTap: onTap,
      margin: context.responsiveMargin,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildImageSection(context), _buildContentSection(context)],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              _imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;

                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primaryContainer,
                        Theme.of(context).colorScheme.secondaryContainer,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Loading fitness image...',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (loadingProgress.expectedTotalBytes != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '${((loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!) * 100).toInt()}%',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.grey[300]!, Colors.grey[100]!],
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Fitness Image',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Unable to load',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              plan.level,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: context.responsivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plan.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: Responsive.responsiveFontSize(
                context,
                mobile: 18,
                tablet: 20,
                desktop: 22,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                plan.time,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.room,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                'Room ${plan.room}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.person,
                size: 16,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(width: 4),
              Text(
                'Trainer: ${plan.trainer}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
