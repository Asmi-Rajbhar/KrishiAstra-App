import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:krishiastra/app/features/crop_guide/domain/entities/environmental_stress.dart';
import 'package:krishiastra/app/features/crop_guide/domain/repositories/i_crop_guide_repository.dart';

import 'package:krishiastra/app/features/crop_variety/presentation/providers/crop_provider.dart';

class EnvironmentalStressPage extends StatefulWidget {
  const EnvironmentalStressPage({super.key});

  @override
  State<EnvironmentalStressPage> createState() =>
      _EnvironmentalStressPageState();
}

class _EnvironmentalStressPageState extends State<EnvironmentalStressPage> {
  bool _isLoading = true;
  String? _error;
  EnvironmentalStress? _stress;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final provider = context.read<CropProvider>();
      final varietyId = provider.selectedVariety?.name;

      if (varietyId == null) {
        if (mounted) {
          setState(() {
            _error = "Please select a variety first";
            _isLoading = false;
          });
        }
        return;
      }

      final result = await context
          .read<ICropGuideRepository>()
          .getEnvironmentalStress(varietyId);
      if (mounted) {
        setState(() {
          if (result.isSuccess) {
            final list = result.data!;
            if (list.isNotEmpty) {
              _stress = list.first;
            }
          } else {
            _error = result.failure?.message;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        leadingIcon: AppIcons.arrowBackIosNew,
        titleText: AppLocalizations.of(context)!.environmentalStress,
      ),
      body: _buildBody(),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accentGreen),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(
          "${AppLocalizations.of(context)!.errorLabel} $_error",
          style: const TextStyle(color: AppColors.redShade),
        ),
      );
    }

    if (_stress == null) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noStressDataAvailable),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
      children: [
        const SizedBox(height: AppSizes.lg),
        _buildHeroSection(context),
        const SizedBox(height: AppSizes.lg),
        _buildInfoDetails(context),
        const SizedBox(height: AppSizes.xl * 3),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return HeroCard.single(
      imageUrl:
          'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=1000&auto=format&fit=crop',
      title: _stress!.stressName,
      subtitle: 'Environmental Stress Guide',
      badgeText: _stress!.severityLevel.toUpperCase(),
      badgeColor: _mapSeverityColor(_stress!.severityLevel),
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      height: 220,
    );
  }

  Widget _buildInfoDetails(BuildContext context) {
    return Column(
      children: [
        InfoSection.list(
          context: context,
          title: 'Visual Symptoms',
          icon: Icons.remove_red_eye_outlined,
          items: _splitContentToInfoItems(
            _stress!.symptoms,
            icon: Icons.visibility,
            iconColor: AppColors.accentGreen,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        InfoSection.list(
          context: context,
          title: 'Potential Causes',
          icon: Icons.help_outline,
          items: _splitContentToInfoItems(
            _stress!.causes,
            icon: Icons.warning_amber_rounded,
            iconColor: AppColors.orangeShade,
          ),
        ),
        const SizedBox(height: 16),
        InfoSection.list(
          context: context,
          title: 'Impact on Crop',
          icon: Icons.trending_down,
          items: _splitContentToInfoItems(
            _stress!.impactOnCrop,
            icon: Icons.error_outline,
            iconColor: AppColors.redShade,
          ),
        ),
        const SizedBox(height: 16),
        InfoSection.list(
          context: context,
          title: 'Management Guide',
          icon: Icons.health_and_safety_outlined,
          items: _splitContentToInfoItems(
            _stress!.preventiveMeasures,
            icon: Icons.check_circle_outline,
            iconColor: AppColors.blueShade,
          ),
        ),
      ],
    );
  }

  List<InfoItem> _splitContentToInfoItems(
    String content, {
    required IconData icon,
    required Color iconColor,
  }) {
    return content
        .split(RegExp(r'\n|•'))
        .where((s) => s.trim().isNotEmpty)
        .map(
          (point) =>
              InfoItem(content: point.trim(), icon: icon, iconColor: iconColor),
        )
        .toList();
  }

  Color _mapSeverityColor(String? severity) {
    if (severity == null) return AppColors.accentGreen;
    switch (severity.toLowerCase()) {
      case 'high':
      case 'severe':
        return AppColors.redShade;
      case 'medium':
      case 'moderate':
        return AppColors.orangeShade;
      case 'low':
        return AppColors.yellowShade;
      default:
        return AppColors.accentGreen;
    }
  }
}
