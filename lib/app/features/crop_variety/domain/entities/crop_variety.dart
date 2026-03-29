import 'package:flutter/material.dart';

class CropVariety {
  final String name;
  final String imageUrl;
  final String? badgeText;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final bool isPrimaryAction;
  final String? parentage;
  final String? expectedYield;
  final String? maturity;
  final String? sucrosePercentage;
  final String? resistance;
  final String? soilType;
  final String? season;
  final String? expertRecommendation;

  CropVariety({
    required this.name,
    required this.imageUrl,
    this.badgeText,
    this.badgeColor,
    this.badgeTextColor,
    this.isPrimaryAction = false,
    this.parentage,
    this.expectedYield,
    this.maturity,
    this.sucrosePercentage,
    this.resistance,
    this.soilType,
    this.season,
    this.expertRecommendation,
  });
}
