import 'package:equatable/equatable.dart';

class CropLifecycleStage extends Equatable {
  final String stageName;
  final String cropSeason;
  final String crop;
  final String cropVariety;
  final String cropParentage;
  final List<String> whatToDo;
  final List<String> whatToAvoid;
  final List<StageArticle> articles;
  final List<StageVideo> videos;
  final List<StageTask> timeBoundChecklist;

  const CropLifecycleStage({
    required this.stageName,
    required this.cropSeason,
    required this.crop,
    required this.cropVariety,
    required this.cropParentage,
    required this.whatToDo,
    required this.whatToAvoid,
    required this.articles,
    required this.videos,
    required this.timeBoundChecklist,
  });

  factory CropLifecycleStage.fromJson(Map<String, dynamic> json) {
    // Helper to try multiple keys and return as a string
    String tryKeys(List<String> keys) {
      for (var key in keys) {
        if (json[key] != null) return json[key].toString();
      }
      return '';
    }

    // Helper to find a list under multiple potential keys
    List<String> tryListKeys(List<String> keys) {
      for (var key in keys) {
        final val = json[key];
        if (val is List) return val.map((e) => e.toString()).toList();
        if (val is String && val.isNotEmpty) return [val];
      }
      return [];
    }

    return CropLifecycleStage(
      stageName: tryKeys([
        'stage',
        'stages',
        'stage_name',
        'stage_title',
        'title',
        'name',
      ]),
      cropSeason: tryKeys(['crop_season', 'season']),
      crop: tryKeys(['crop', 'crop_name']),
      cropVariety: tryKeys(['crop_variety', 'variety']),
      cropParentage: tryKeys(['crop_parentage']),
      whatToDo: tryListKeys(['what_to_do', 'actions', 'tasks', 'to_do']),
      whatToAvoid: tryListKeys(['what_to_avoid', 'hazards', 'warnings']),
      articles: _parseArticles(
        json['articles'] ?? json['content_library'] ?? json['article_list'],
      ),
      videos: _parseVideos(
        json['video'] ??
            json['videos'] ??
            json['video_list'] ??
            json['content_library'],
      ),
      timeBoundChecklist: _parseChecklist(
        json['time_bound_checklist'] ?? json['checklist'],
      ),
    );
  }

  static List<StageTask> _parseChecklist(dynamic json) {
    if (json is List && json.isNotEmpty) {
      // Check if it's the list-of-lists format (Real API)
      if (json.first is List) {
        final List<StageTask> tasks = [];
        // Skip the header row if it contains "Task Title"
        int startIdx = 0;
        if (json.first.toString().contains('Task Title')) {
          startIdx = 1;
        }

        for (var i = startIdx; i < json.length; i++) {
          final row = json[i];
          if (row is List && row.length >= 4) {
            tasks.add(
              StageTask(
                taskTitle: row[0]?.toString() ?? '',
                taskDescription: row[1]?.toString() ?? '',
                startDay: int.tryParse(row[2]?.toString() ?? '0') ?? 0,
                endDay: int.tryParse(row[3]?.toString() ?? '0') ?? 0,
                isReminderEnabled: false,
              ),
            );
          }
        }
        return tasks;
      }
      // Fallback to the old format (Map based)
      return json
          .whereType<Map<String, dynamic>>()
          .map((e) => StageTask.fromJson(e))
          .toList();
    }
    return [];
  }

  static List<StageArticle> _parseArticles(dynamic json) {
    if (json is List) {
      final List<StageArticle> articles = [];
      for (var item in json) {
        if (item is Map<String, dynamic>) {
          // The API returns a list of maps where keys are article titles
          // We iterate through values to get the actual article object
          for (var value in item.values) {
            if (value is Map<String, dynamic>) {
              articles.add(StageArticle.fromJson(value));
            }
          }
        }
      }
      return articles;
    }
    return [];
  }

  static List<StageVideo> _parseVideos(dynamic json) {
    if (json is List) {
      final List<StageVideo> videos = [];
      for (var item in json) {
        if (item is Map<String, dynamic>) {
          // Check if it's the direct video object or a map with title keys
          if (item.containsKey('url') || item.containsKey('provider')) {
            videos.add(StageVideo.fromJson(item));
          } else {
            // The API sometimes returns a list of maps where keys are video titles
            for (var value in item.values) {
              if (value is Map<String, dynamic>) {
                videos.add(StageVideo.fromJson(value));
              }
            }
          }
        }
      }
      return videos;
    } else if (json is Map) {
      // Single video object
      final Map<String, dynamic> map = Map<String, dynamic>.from(json);
      return [StageVideo.fromJson(map)];
    }
    return [];
  }

  @override
  List<Object?> get props => [
    stageName,
    cropSeason,
    crop,
    cropVariety,
    cropParentage,
    whatToDo,
    whatToAvoid,
    articles,
    videos,
    timeBoundChecklist,
  ];

  CropLifecycleStage copyWith({
    String? stageName,
    String? cropSeason,
    String? crop,
    String? cropVariety,
    String? cropParentage,
    List<String>? whatToDo,
    List<String>? whatToAvoid,
    List<StageArticle>? articles,
    List<StageVideo>? videos,
    List<StageTask>? timeBoundChecklist,
  }) {
    return CropLifecycleStage(
      stageName: stageName ?? this.stageName,
      cropSeason: cropSeason ?? this.cropSeason,
      crop: crop ?? this.crop,
      cropVariety: cropVariety ?? this.cropVariety,
      cropParentage: cropParentage ?? this.cropParentage,
      whatToDo: whatToDo ?? this.whatToDo,
      whatToAvoid: whatToAvoid ?? this.whatToAvoid,
      articles: articles ?? this.articles,
      videos: videos ?? this.videos,
      timeBoundChecklist: timeBoundChecklist ?? this.timeBoundChecklist,
    );
  }
}

class StageArticle extends Equatable {
  final String title;
  final String author;
  final String description;
  final String? url;

  const StageArticle({
    required this.title,
    required this.author,
    required this.description,
    this.url,
  });

  factory StageArticle.fromJson(Map<String, dynamic> json) {
    return StageArticle(
      title: json['title']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      url: json['url']?.toString(),
    );
  }

  @override
  List<Object?> get props => [title, author, description, url];

  StageArticle copyWith({
    String? title,
    String? author,
    String? description,
    String? url,
  }) {
    return StageArticle(
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      url: url ?? this.url,
    );
  }
}

class StageVideo extends Equatable {
  final String title;
  final String provider;
  final String url;
  final String description;
  final double duration;

  const StageVideo({
    required this.title,
    required this.provider,
    required this.url,
    required this.description,
    required this.duration,
  });

  factory StageVideo.fromJson(Map<String, dynamic> json) {
    return StageVideo(
      title: json['title']?.toString() ?? '',
      provider: json['provider']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      duration: _parseDuration(json['duration']),
    );
  }

  static double _parseDuration(dynamic duration) {
    if (duration is num) return duration.toDouble();
    if (duration is String) {
      try {
        final hoursMatch = RegExp(r'(\d+)h').firstMatch(duration);
        final minutesMatch = RegExp(r'(\d+)m').firstMatch(duration);
        final secondsMatch = RegExp(r'(\d+)s').firstMatch(duration);

        double hours = double.tryParse(hoursMatch?.group(1) ?? '0') ?? 0.0;
        double mins = double.tryParse(minutesMatch?.group(1) ?? '0') ?? 0.0;
        double secs = double.tryParse(secondsMatch?.group(1) ?? '0') ?? 0.0;

        return (hours * 60.0) + mins + (secs / 60.0);
      } catch (_) {
        return 0.0;
      }
    }
    return 0.0;
  }

  @override
  List<Object?> get props => [title, provider, url, description, duration];

  StageVideo copyWith({
    String? title,
    String? provider,
    String? url,
    String? description,
    double? duration,
  }) {
    return StageVideo(
      title: title ?? this.title,
      provider: provider ?? this.provider,
      url: url ?? this.url,
      description: description ?? this.description,
      duration: duration ?? this.duration,
    );
  }
}

class StageTask extends Equatable {
  final String taskTitle;
  final String taskDescription;
  final int startDay;
  final int endDay;
  final bool isReminderEnabled;

  const StageTask({
    required this.taskTitle,
    required this.taskDescription,
    required this.startDay,
    required this.endDay,
    required this.isReminderEnabled,
  });

  factory StageTask.fromJson(Map<String, dynamic> json) {
    return StageTask(
      taskTitle: json['task_title']?.toString() ?? '',
      taskDescription: json['task_description']?.toString() ?? '',
      startDay: (json['start_day'] as num?)?.toInt() ?? 0,
      endDay: (json['end_day'] as num?)?.toInt() ?? 0,
      isReminderEnabled: (json['is_reminder_enabled'] as num?) == 1,
    );
  }

  @override
  List<Object?> get props => [
    taskTitle,
    taskDescription,
    startDay,
    endDay,
    isReminderEnabled,
  ];

  StageTask copyWith({
    String? taskTitle,
    String? taskDescription,
    int? startDay,
    int? endDay,
    bool? isReminderEnabled,
  }) {
    return StageTask(
      taskTitle: taskTitle ?? this.taskTitle,
      taskDescription: taskDescription ?? this.taskDescription,
      startDay: startDay ?? this.startDay,
      endDay: endDay ?? this.endDay,
      isReminderEnabled: isReminderEnabled ?? this.isReminderEnabled,
    );
  }
}
