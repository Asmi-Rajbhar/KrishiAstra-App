// lib/models/field_config.dart
import 'package:flutter/material.dart';

class FieldConfig {
  final String key;
  final String label;
  final IconData icon;
  final Color color;
  final String description;

  FieldConfig({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.description,
  });
}

final List<FieldConfig> fieldConfigs = [
  FieldConfig(
    key: 'about_crop',
    label: 'About Crop',
    icon: Icons.book,
    color: const Color(0xFF10b981),
    description: 'Learn about the crop origin and characteristics',
  ),
  FieldConfig(
    key: 'climate_requirements',
    label: 'Climate Requirements',
    icon: Icons.wb_sunny,
    color: const Color(0xFF3b82f6),
    description: 'Temperature, rainfall and humidity needs',
  ),
  FieldConfig(
    key: 'planting_season',
    label: 'Planting Season',
    icon: Icons.calendar_today,
    color: const Color(0xFF8b5cf6),
    description: 'Optimal planting time and methods',
  ),
  FieldConfig(
    key: 'varieties',
    label: 'Varieties',
    icon: Icons.grass,
    color: const Color(0xFF059669),
    description: 'Recommended crop varieties and yields',
  ),
  FieldConfig(
    key: 'field_preparation',
    label: 'Field Preparation',
    icon: Icons.agriculture,
    color: const Color(0xFFd97706),
    description: 'Land preparation and soil management',
  ),
  FieldConfig(
    key: 'production_techniques',
    label: 'Production Techniques',
    icon: Icons.settings,
    color: const Color(0xFFdc2626),
    description: 'Seed treatment and planting methods',
  ),
  FieldConfig(
    key: 'irrigation_management',
    label: 'Irrigation Management',
    icon: Icons.water_drop,
    color: const Color(0xFF0891b2),
    description: 'Water requirements and scheduling',
  ),
  FieldConfig(
    key: 'nutrient_management',
    label: 'Nutrient Management',
    icon: Icons.science,
    color: const Color(0xFF7c3aed),
    description: 'Fertilizer recommendations and doses',
  ),
  FieldConfig(
    key: 'weed_management',
    label: 'Weed Management',
    icon: Icons.yard,
    color: const Color(0xFF16a34a),
    description: 'Weed control strategies',
  ),
  FieldConfig(
    key: 'insect_pest_management',
    label: 'Insect Pest Management',
    icon: Icons.bug_report,
    color: const Color(0xFFea580c),
    description: 'Pest identification and control',
  ),
  FieldConfig(
    key: 'disease_management',
    label: 'Disease Management',
    icon: Icons.medical_services,
    color: const Color(0xFFdc2626),
    description: 'Disease prevention and treatment',
  ),
  FieldConfig(
    key: 'ratoon_management',
    label: 'Ratoon Management',
    icon: Icons.autorenew,
    color: const Color(0xFF0d9488),
    description: 'Managing ratoon crops',
  ),
  FieldConfig(
    key: 'post_harvest_management',
    label: 'Post-harvest Management',
    icon: Icons.warehouse,
    color: const Color(0xFF4f46e5),
    description: 'Harvesting and storage practices',
  ),
  FieldConfig(
    key: 'mechanization',
    label: 'Mechanization',
    icon: Icons.precision_manufacturing,
    color: const Color(0xFF64748b),
    description: 'Farm machinery and equipment',
  ),
];