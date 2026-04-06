import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_info.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety.dart';
import 'package:krishiastra/app/features/crop_variety/domain/repositories/i_crop_repository.dart';
import 'package:krishiastra/app/core/utils/result.dart';

class CropProvider extends ChangeNotifier {
  final ICropRepository _repository;
  static const String _varietyKey = 'selected_crop_variety';
  static const String _cropKey = 'selected_crop_name';
  static const String _seasonKey = 'selected_crop_season';

  List<CropVariety> _varieties = [];
  CropInfo? _cropInfo;
  CropVariety? _selectedVariety;
  String? _selectedCropName;
  String? _selectedSeason;
  List<String> _availableSeasons = [];
  bool _isLoading = false;
  String? _error;

  CropProvider(this._repository);

  List<CropVariety> get varieties => _varieties;
  CropInfo? get cropInfo => _cropInfo;
  CropVariety? get selectedVariety => _selectedVariety;
  String? get selectedCropName => _selectedCropName;
  String? get selectedSeason => _selectedSeason;
  List<String> get availableSeasons => _availableSeasons;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    Future.microtask(notifyListeners);

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCropName = prefs.getString(_cropKey);

        // ADD THIS
        debugPrint('=== CROP PROVIDER DEBUG ===');
        debugPrint('savedCropName: $savedCropName');

      if (savedCropName == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      _selectedCropName = savedCropName;

      final results = await Future.wait([
        _repository.getVarieties(savedCropName),
        _repository.getCropInfo(savedCropName),
        _repository.getAvailableCropSeasons(savedCropName),
      ]);

      final varietiesResult = results[0] as Result<List<CropVariety>>;
      final cropInfoResult = results[1] as Result<CropInfo>;
      final seasonsResult = results[2] as Result<List<String>>;

      if (varietiesResult.isSuccess) {
        _varieties = varietiesResult.data!;
      } else {
        _error = varietiesResult.failure?.message;
      }

      if (cropInfoResult.isSuccess) {
        _cropInfo = cropInfoResult.data;
         // ADD THIS
        debugPrint('cropInfo loaded: ${_cropInfo?.name}');
      } else {
        _error ??= cropInfoResult.failure?.message;
        // ADD THIS
        debugPrint('cropInfo FAILED: ${cropInfoResult.failure?.message}');
      }

      if (seasonsResult.isSuccess) {
        _availableSeasons = seasonsResult.data ?? [];
      }

      // Restore saved season; auto-pick first if none saved yet
      final savedSeason = prefs.getString(_seasonKey);
      if (savedSeason != null && _availableSeasons.contains(savedSeason)) {
        _selectedSeason = savedSeason;
      } else if (_availableSeasons.isNotEmpty) {
        _selectedSeason = _availableSeasons.first;
      }

      // Load saved variety
      final savedVarietyName = prefs.getString(_varietyKey);
      if (savedVarietyName != null && _varieties.isNotEmpty) {
        _selectedVariety = _varieties.firstWhere(
          (v) => v.name == savedVarietyName,
          orElse: () => _varieties.first,
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('CropProvider: Error loading data: $e');
      _error ??= e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateVariety(CropVariety variety) async {
    _selectedVariety = variety;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_varietyKey, variety.name);
      if (_cropInfo != null) {
        await prefs.setString(_cropKey, _cropInfo!.name);
        _selectedCropName = _cropInfo!.name;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Failed to save variety: $e');
    }
  }

  /// Persists the chosen season and notifies all listeners.
  Future<void> updateSeason(String season) async {
    if (_selectedSeason == season) return;
    _selectedSeason = season;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_seasonKey, season);
    } catch (e) {
      if (kDebugMode) debugPrint('CropProvider: Failed to save season: $e');
    }
  }

  Future<void> updateCrop(String cropName) async {
    if (_selectedCropName == cropName) return;

    _selectedCropName = cropName;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cropKey, cropName);

      final results = await Future.wait([
        _repository.getVarieties(cropName),
        _repository.getCropInfo(cropName),
        _repository.getAvailableCropSeasons(cropName),
      ]);

      final varietiesResult = results[0] as Result<List<CropVariety>>;
      final cropInfoResult = results[1] as Result<CropInfo>;
      final seasonsResult = results[2] as Result<List<String>>;

      if (varietiesResult.isSuccess) {
        _varieties = varietiesResult.data!;
        // Reset variety selection when crop changes
        _selectedVariety = null;
        await prefs.remove(_varietyKey);
      }

      if (cropInfoResult.isSuccess) {
        _cropInfo = cropInfoResult.data;
      }

      if (seasonsResult.isSuccess) {
        _availableSeasons = seasonsResult.data ?? [];
        // Reset season when crop changes — pick first available
        _selectedSeason = _availableSeasons.isNotEmpty
            ? _availableSeasons.first
            : null;
        final prefs2 = await SharedPreferences.getInstance();
        if (_selectedSeason != null) {
          await prefs2.setString(_seasonKey, _selectedSeason!);
        } else {
          await prefs2.remove(_seasonKey);
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool get hasSelection => _selectedVariety != null;
}
