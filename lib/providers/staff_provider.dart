import 'package:flutter/foundation.dart';
import '../models/staff_member.dart';

class StaffProvider extends ChangeNotifier {
  final List<StaffMember> _staff = [
    StaffMember(
      id: '1',
      name: 'Ramesh Yadav',
      salary: 12000,
      advance: 2000,
      paymentDate: DateTime.now().add(const Duration(days: 15)),
    ),
    StaffMember(
      id: '2',
      name: 'Sunita Devi',
      salary: 10000,
      advance: 0,
      paymentDate: DateTime.now().add(const Duration(days: 15)),
    ),
  ];

  List<StaffMember> get staff => List.unmodifiable(_staff);

  double get totalSalary =>
      _staff.fold(0.0, (sum, s) => sum + s.salary);

  double get totalAdvance =>
      _staff.fold(0.0, (sum, s) => sum + s.advance);

  void addStaff(StaffMember member) {
    _staff.insert(0, member);
    notifyListeners();
  }

  void updateStaff(StaffMember member) {
    final index = _staff.indexWhere((s) => s.id == member.id);
    if (index != -1) {
      _staff[index] = member;
      notifyListeners();
    }
  }

  void deleteStaff(String id) {
    _staff.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}
