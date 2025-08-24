import 'plan.dart';

class DayPlans {
  final String date; 
  final List<Plan> plans;

  DayPlans({required this.date, required this.plans});

  factory DayPlans.fromJson(Map<String, dynamic> j) => DayPlans(
    date: j['date']?.toString() ?? '',
    plans: (j['plans'] as List? ?? [])
        .map((e) => Plan.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
  );

  Map<String, dynamic> toPostBody() => {
    'date': date,
    'plans': plans.map((e) => e.toJsonForPost()).toList(),
  };
}
