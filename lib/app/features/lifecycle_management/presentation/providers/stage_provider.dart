import 'package:flutter/material.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/entities/checklist_item.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/repositories/i_lifecycle_repository.dart';
import 'package:krishiastra/app/core/utils/result.dart';

class StageProvider extends ChangeNotifier {
  final ILifecycleRepository _repository;

  List<ChecklistItem> _checklist = [];
  bool _isLoading = false;
  String? _error;

  StageProvider(this._repository);

  List<ChecklistItem> get checklist => _checklist;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadChecklist(String stageNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final Result<List<ChecklistItem>> result = await _repository.getChecklist(
        stageNumber,
      );
      if (result.isSuccess) {
        _checklist = result.data!;
      } else {
        _error = result.failure?.message;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleCompletion(int index, bool? value) {
    if (index >= 0 && index < _checklist.length) {
      _checklist[index].isCompleted = value ?? false;
      notifyListeners();
    }
  }

  void toggleReminder(int index) {
    if (index >= 0 && index < _checklist.length) {
      _checklist[index].isReminderActive = !_checklist[index].isReminderActive;
      notifyListeners();
    }
  }
}
