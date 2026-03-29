import 'package:krishiastra/app/features/lifecycle_management/domain/entities/stage_status.dart';
import 'package:flutter/material.dart';

class LifecycleStage {
  final String number;
  final IconData icon;
  final String title;
  final String desc;
  final StageStatus status;

  LifecycleStage({
    required this.number,
    required this.icon,
    required this.title,
    required this.desc,
    required this.status,
  });

  factory LifecycleStage.fromMap(Map<String, dynamic> map) {
    return LifecycleStage(
      number: map['number'],
      icon: map['icon'],
      title: map['title'],
      desc: map['desc'],
      status: map['status'],
    );
  }
}
