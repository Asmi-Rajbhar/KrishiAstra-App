import 'package:flutter/material.dart';

enum DiagnosticType { pest, disease, nutrient, environment }

/// Model class for diagnostic categories
class DiagnosticCategory {
  final DiagnosticType type;
  final String title;
  final String description;
  final String footer;

  final IconData icon;

  const DiagnosticCategory({
    required this.type,
    required this.title,
    required this.description,
    required this.footer,
    required this.icon,
  });

  DiagnosticCategory copyWith({
    DiagnosticType? type,
    String? title,
    String? description,
    String? footer,
    IconData? icon,
  }) {
    return DiagnosticCategory(
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      footer: footer ?? this.footer,
      icon: icon ?? this.icon,
    );
  }
}
