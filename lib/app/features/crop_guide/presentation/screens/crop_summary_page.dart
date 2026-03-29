import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_info.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_basic_details.dart';
import 'package:krishiastra/app/features/crop_variety/domain/repositories/i_crop_repository.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_summary/crop_summary_bloc.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_summary/crop_summary_event.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_summary/crop_summary_state.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Note: I noticed an import issue in the previous version. I need to ensure the state import is correct.
// Let me double check where CropSummaryState is defined.
// From the previous view_file, it was:
// import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_summary/crop_summary_state.dart';

class CropSummaryPage extends StatefulWidget {
  final CropInfo cropInfo;

  const CropSummaryPage({super.key, required this.cropInfo});

  @override
  State<CropSummaryPage> createState() => _CropSummaryPageState();
}

class _CropSummaryPageState extends State<CropSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CropSummaryBloc(repository: context.read<ICropRepository>())
            ..add(FetchCropSummaryEvent(widget.cropInfo.cropName)),
      child: BlocBuilder<CropSummaryBloc, CropSummaryState>(
        builder: (context, state) {
          if (state is CropSummaryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          } else if (state is CropSummaryError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: AppSizes.iconXl * 1.5,
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      "${AppLocalizations.of(context)!.errorLabel} ${state.message}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.error),
                    ),
                    const SizedBox(height: AppSizes.md),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CropSummaryBloc>().add(
                          FetchCropSummaryEvent(widget.cropInfo.cropName),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.retry),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is CropSummaryLoaded) {
            return _buildContent(context, state.details);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, CropBasicDetails details) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            // Module Complete badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                border: Border.all(
                  color: AppColors.neonGreen.withValues(alpha: 0.4),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.accentGreen,
                    size: AppSizes.iconSm,
                  ),
                  SizedBox(width: AppSizes.xs),
                  Text(
                    'Module Complete',
                    style: TextStyle(
                      color: AppColors.accentGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: AppSizes.fontCaption,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // Trophy icon
            Container(
              width: AppSizes.xl * 2.5,
              height: AppSizes.xl * 2.5,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.neonGreen, AppColors.accentGreen],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonGreen.withValues(alpha: 0.35),
                    blurRadius: AppSizes.md,
                    spreadRadius: AppSizes.xs,
                  ),
                ],
              ),
              child: const Icon(
                Icons.emoji_events,
                color: AppColors.white,
                size: AppSizes.xl * 1.5,
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // Title
            const Text(
              'Ready to Plant?',
              style: TextStyle(
                fontSize: AppSizes.fontHero,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              '${details.cropName.isNotEmpty ? details.cropName : widget.cropInfo.cropName} Mastery',
              style: const TextStyle(
                fontSize: AppSizes.fontContent,
                fontWeight: FontWeight.w600,
                color: AppColors.accentGreen,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              'Achieved',
              style: TextStyle(
                fontSize: AppSizes.fontContent,
                fontWeight: FontWeight.w600,
                color: AppColors.accentGreen,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Congratulations! You have mastered the essentials of ${widget.cropInfo.cropName} cultivation. Review your final readiness checklist below to ensure a successful harvest.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppSizes.fontBody,
                color: AppColors.grey500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // Final Checklist
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.06),
                    blurRadius: AppSizes.md,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Final Checklist',
                    style: TextStyle(
                      fontSize: AppSizes.fontContent,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  _buildChecklistItem(
                    'Climate & Soil ready',
                    details.climateNeeds.isNotEmpty
                        ? details.climateNeeds
                        : 'pH levels and nutrients optimized',
                  ),
                  _buildChecklistItem(
                    'Water source confirmed',
                    details.waterIntensive.isNotEmpty
                        ? details.waterIntensive
                        : 'Irrigation system is operational',
                  ),
                  _buildChecklistItem(
                    'Lifecycle understood',
                    'Harvest timeline and care plan set for ${details.maturityTime} months',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // Potential income card
            _RevenueCard(
              cropInfo: widget.cropInfo,
              revenue: details.revenue > 0 ? details.revenue : null,
            ),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: AppSizes.iconMd + 2,
            height: AppSizes.iconMd + 2,
            decoration: const BoxDecoration(
              color: AppColors.neonGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: AppColors.primaryColor,
              size: AppSizes.iconSm,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppSizes.fontBody,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: AppSizes.fontCaption,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RevenueCard extends StatefulWidget {
  final CropInfo cropInfo;
  final num? revenue;

  const _RevenueCard({required this.cropInfo, this.revenue});

  @override
  State<_RevenueCard> createState() => _RevenueCardState();
}

class _RevenueCardState extends State<_RevenueCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final displayRevenue = widget.revenue != null
        ? '₹ ${widget.revenue} L'
        : (widget.cropInfo.potentialIncome.isNotEmpty
              ? widget.cropInfo.potentialIncome
              : '₹ 6.5 L');
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryColor, AppColors.green800],
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          boxShadow: [
            if (_isExpanded)
              BoxShadow(
                color: AppColors.primaryColor.withValues(alpha: 0.4),
                blurRadius: AppSizes.lg,
                offset: const Offset(0, 8),
              )
            else
              BoxShadow(
                color: AppColors.primaryColor.withValues(alpha: 0.2),
                blurRadius: AppSizes.md,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: AppColors.neonGreen,
                    size: AppSizes.iconXl,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Profit',
                        style: TextStyle(
                          color: AppColors.white70,
                          fontSize: AppSizes.fontCaption,
                        ),
                      ),
                      Text(
                        displayRevenue,
                        style: const TextStyle(
                          color: AppColors.neonGreen,
                          fontSize: AppSizes.fontHeading,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'per acre / harvest',
                        style: TextStyle(
                          color: AppColors.white70,
                          fontSize: AppSizes.fontCaption,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.white,
                  size: AppSizes.iconXl,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),

            // Expected Revenue & Investment Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem(
                  'Expected Revenue',
                  '₹ 1,20,000',
                  Icons.arrow_upward,
                  AppColors.neonGreen,
                ),
                Container(
                  height: AppSizes.xl,
                  width: 1,
                  color: AppColors.white70,
                ),
                _buildSummaryItem(
                  'Expected Investment',
                  '₹ 55,000',
                  Icons.arrow_downward,
                  AppColors.error,
                ),
              ],
            ),

            // Expanded Section
            ClipRect(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.topCenter,
                heightFactor: _isExpanded ? 1.0 : 0.0,
                child: Column(
                  children: [
                    const SizedBox(height: AppSizes.md),
                    const Divider(color: AppColors.white70),
                    const SizedBox(height: AppSizes.md),
                    const Text(
                      'In-Depth Breakdown (per acre)',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: AppSizes.fontContent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    _buildDetailRow(
                      'Seed & Sowing',
                      '₹ 15,000',
                      AppColors.white70,
                    ),
                    const SizedBox(height: AppSizes.sm),
                    _buildDetailRow(
                      'Fertilizer',
                      '₹ 12,000',
                      AppColors.white70,
                    ),
                    const SizedBox(height: AppSizes.sm),
                    _buildDetailRow(
                      'Irrigation & Labor',
                      '₹ 18,000',
                      AppColors.white70,
                    ),
                    const SizedBox(height: AppSizes.sm),
                    _buildDetailRow(
                      'Harvesting',
                      '₹ 10,000',
                      AppColors.white70,
                    ),
                    const SizedBox(height: AppSizes.md),
                    const Divider(color: AppColors.white70),
                    const SizedBox(height: AppSizes.sm),
                    _buildDetailRow(
                      'Total Investment',
                      '₹ 55,000',
                      AppColors.white,
                      isBold: true,
                    ),
                    const SizedBox(height: AppSizes.sm),
                    _buildDetailRow(
                      'Expected Returns',
                      '₹ 1,20,000',
                      AppColors.neonGreen,
                      isBold: true,
                    ),
                    const SizedBox(height: AppSizes.sm),
                    _buildDetailRow(
                      'Total Profit',
                      '₹ 65,000',
                      AppColors.neonGreen,
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: AppSizes.iconSm - 2, color: color),
            const SizedBox(width: AppSizes.xs),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.white70,
                fontSize: AppSizes.fontCaption,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: AppSizes.fontContent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    String title,
    String cost,
    Color color, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: AppSizes.fontCaption,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Text(
          cost,
          style: TextStyle(
            color: color,
            fontSize: AppSizes.fontBody,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
