import 'package:flutter/foundation.dart';
import '../core/repository/plan_repository.dart';
import '../core/utils/date_utils.dart';
import '../data/models/day_plans.dart';
import '../data/models/plan.dart';

class PlanViewModel extends ChangeNotifier {
  final PlanRepository _repo = PlanRepository();

  DayPlans? _day;
  DayPlans? get day => _day;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  DateTime selectedDate = DateTime.now();

  void bootstrap() {
    loadForDate(selectedDate);
  }

  Future<void> loadForDate(DateTime date) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final d = DateFmt.yMd(date);
      _day = await _repo.fetchPlans(d);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void setDate(DateTime d) {
    selectedDate = d;
    loadForDate(d);
  }

  Future<String?> save(List<Plan> plans) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final body = DayPlans(date: DateFmt.yMd(selectedDate), plans: plans);
      final msg = await _repo.upsertPlans(body);
      await loadForDate(selectedDate);
      return msg;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
