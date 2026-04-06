import 'package:flutter/material.dart';
import 'package:krishiastra/app/features/video_gallery/domain/entities/video.dart';
import 'package:krishiastra/app/features/video_gallery/domain/repositories/i_video_repository.dart';
import 'package:krishiastra/app/core/utils/result.dart';

class VideoProvider extends ChangeNotifier {
  final IVideoRepository _repository;
  static const int _limit = 4;

  List<Video> _videos = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  bool _hasMore = true;
  int _offset = 0;

  VideoProvider(this._repository);

  List<Video> get videos => _videos;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMore => _hasMore;

  Future<void> loadVideos() async {
    _isLoading = true;
    _error = null;
    _offset = 0;
    _videos = [];
    _hasMore = true;
    notifyListeners();

    try {
      final Result<List<Video>> result = await _repository.getVideos(
        limit: _limit,
        offset: _offset,
      );
      if (result.isSuccess) {
        final newVideos = result.data!;
        _videos.addAll(newVideos);
        _offset += newVideos.length;
        _hasMore = newVideos.length == _limit;
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

  Future<void> loadMoreVideos() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final result = await _repository.getVideos(
        limit: _limit,
        offset: _offset,
      );
      if (result.isSuccess) {
        final newVideos = result.data!;
        _videos.addAll(newVideos);
        _offset += newVideos.length;
        _hasMore = newVideos.length == _limit;
      } else {
        _error = result.failure?.message;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}
