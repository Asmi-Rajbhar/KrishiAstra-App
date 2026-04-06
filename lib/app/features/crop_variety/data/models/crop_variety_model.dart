import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety.dart';
import 'package:flutter/material.dart';

class CropVarietyModel {
  final String name;
  final String yield;
  final String maturity;
  final String? feature;
  final String? badgeColor;
  final String? badgeTextColor;
  final dynamic isPrimaryAction;
  final String image;
  final String? parentage;
  final String? sucrosePercentage;
  final String? resistance;
  final String? soilType;
  final String? season;
  final String? expertRecommendation;

  CropVarietyModel({
    required this.name,
    required this.yield,
    required this.maturity,
    this.feature,
    this.badgeColor,
    this.badgeTextColor,
    this.isPrimaryAction,
    required this.image,
    this.parentage,
    this.sucrosePercentage,
    this.resistance,
    this.soilType,
    this.season,
    this.expertRecommendation,
  });

  factory CropVarietyModel.fromJson(Map<String, dynamic> json) {
    return CropVarietyModel(
      name: json['crop_variety']?.toString() ?? json['name']?.toString() ?? '',
      yield: json['yield']?.toString() ?? '',
      maturity: json['maturity_time']?.toString() ?? '',
      feature: json['feature']?.toString(),
      badgeColor: json['badge_color']?.toString(),
      badgeTextColor: json['badge_text_color']?.toString(),
      isPrimaryAction: json['is_primary_action'],
      image: json['image']?.toString() ?? '',
      parentage: json['parentage']?.toString(),
      sucrosePercentage: json['sucrose_percentage']?.toString(),
      resistance: json['resistance']?.toString(),
      soilType: json['soil_type']?.toString(),
      season: json['crop_season']?.toString(),
      expertRecommendation: json['expert_recommendation']?.toString(),
    );
  }

  CropVariety toEntity(String baseUrl) {
    Color? mapColor(String? colorName) {
      if (colorName == null) return null;
      // Note: This mapping should ideally happen in a theme or utility class
      // but keeping it here for consistency with the previous repository implementation.
      switch (colorName) {
        case 'green100':
          return const Color(0xFFE8F5E9);
        case 'accentGreen':
          return const Color(0xFF4CAF50);
        case 'blue100':
          return const Color(0xFFE3F2FD);
        case 'blue800':
          return const Color(0xFF1565C0);
        case 'orange100':
          return const Color(0xFFFFF3E0);
        case 'orange800':
          return const Color(0xFFEF6C00);
        default:
          return null;
      }
    }

    final imageUrl = image.isNotEmpty
        ? (image.startsWith('http') ? image : '$baseUrl$image')
        : '';

    return CropVariety(
      name: name,
      imageUrl: imageUrl,
      badgeText: feature,
      badgeColor: mapColor(badgeColor),
      badgeTextColor: mapColor(badgeTextColor),
      isPrimaryAction: isPrimaryAction == 1 || isPrimaryAction == true,
      parentage: parentage,
      expectedYield: yield,
      maturity: maturity,
      sucrosePercentage: sucrosePercentage,
      resistance: resistance,
      soilType: soilType,
      season: season,
      expertRecommendation: expertRecommendation,
    );
  }
}
