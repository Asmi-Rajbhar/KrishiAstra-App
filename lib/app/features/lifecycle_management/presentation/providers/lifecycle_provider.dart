import 'package:flutter/material.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/entities/lifecycle_stage.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/repositories/i_lifecycle_repository.dart';
import 'package:krishiastra/app/core/utils/result.dart';

class LifecycleProvider extends ChangeNotifier {
  final ILifecycleRepository _repository;

  List<LifecycleStage> _stages = [];
  bool _isLoading = false;
  String? _error;

  LifecycleProvider(this._repository);

  List<LifecycleStage> get stages => _stages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadStages() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final Result<List<LifecycleStage>> result = await _repository
          .getLifecycleStages();
      if (result.isSuccess) {
        _stages = result.data!;
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
}
