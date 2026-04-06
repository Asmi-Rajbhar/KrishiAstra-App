import 'package:flutter/material.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/diagnostic_category_model.dart';
import 'package:krishiastra/app/features/diagnostics/domain/repositories/i_diagnostic_repository.dart';
import 'package:krishiastra/app/core/utils/result.dart';

class DiagnosticProvider extends ChangeNotifier {
  final IDiagnosticRepository _repository;

  List<DiagnosticCategory> _categories = [];
  bool _isLoading = false;
  String? _error;

  DiagnosticProvider(this._repository);

  List<DiagnosticCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDiagnostics() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final Result<List<DiagnosticCategory>> result = await _repository
          .getDiagnostics();
      if (result.isSuccess) {
        _categories = result.data!;
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
