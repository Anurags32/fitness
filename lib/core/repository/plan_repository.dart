import '../../core/api/api_service.dart';
import '../../data/models/day_plans.dart';

class PlanRepository {
  final ApiService _api = ApiService();

  Future<DayPlans> fetchPlans(String date) async {
    final json = await _api.getPlans(date);
    return DayPlans.fromJson(json);
  }

  Future<String> upsertPlans(DayPlans body) async {
    final json = await _api.upsertPlans(body.toPostBody());
    return json['message']?.toString() ?? 'Success';
  }
}
