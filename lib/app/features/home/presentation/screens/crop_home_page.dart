import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/widgets/navigation/bottom_nav.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_info.dart';
import 'package:krishiastra/app/features/crop_variety/domain/repositories/i_crop_repository.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/screens/variety_page.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/screens/crop_lifecycle_page.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/screens/crop_overview_page.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/screens/crop_requirements_page.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/screens/crop_risks_page.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/screens/crop_summary_page.dart';
import 'package:krishiastra/app/core/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CropHomePage extends StatefulWidget {
  final String? cropName;
  final int initialIndex;

  const CropHomePage({super.key, this.cropName, this.initialIndex = 0});

  @override
  State<CropHomePage> createState() => _CropHomePageState();
}

class _CropHomePageState extends State<CropHomePage> {
  late Future<CropInfo?> _cropInfoFuture;

  @override
  void initState() {
    super.initState();
    _loadCropInfo();
  }

  void _loadCropInfo() {
    final repository = context.read<ICropRepository>();
    final cropName = widget.cropName;
    if (cropName == null) {
      _cropInfoFuture = Future.value();
      return;
    }
    _cropInfoFuture = repository.getCropInfo(cropName).then((result) {
      if (result.isSuccess && result.data != null) {
        var data = result.data!;
        if (data.duration.isEmpty) {
          return CropInfo(
            name: data.name,
            cropName: data.cropName,
            scientificName: data.scientificName.isNotEmpty
                ? data.scientificName
                : 'Saccharum officinarum',
            cropDescription:
                "The world's primary source of sugar. A robust perennial grass cultivated in tropical and subtropical regions.",
            imageUrl: data.imageUrl,
            duration: '12 Months',
            season: 'Spring / Autumn',
            yieldRange: '80-100 tons/acre',
            soilType: 'Loamy / Clay',
            waterRequirement: 'High (~1500mm)',
            potentialIncome: '₹2L/acre',
            fertilizerRequirement: 'High',
            laborIntensity: 'Medium',
            risks: ['Red Rot Disease', 'Woolly Aphid', 'Shoot Borer'],
          );
        }
        return data;
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 6,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.white,
              size: 20,
            ),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.pop(context);
              } else {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
              }
            },
          ),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.neonGreen,
            indicatorWeight: AppSizes.xs,
            labelColor: AppColors.neonGreen,
            unselectedLabelColor: AppColors.white70,
            labelStyle: const TextStyle(
              fontSize: AppSizes.fontCaption,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: AppSizes.fontCaption,
              fontWeight: FontWeight.w400,
            ),
            tabs: [
              Tab(text: l10n.overview),
              Tab(text: l10n.climaticRequirementsTitle),
              Tab(text: l10n.lifecycle),
              Tab(text: l10n.risksAndCare),
              Tab(text: l10n.varieties),
              Tab(text: l10n.summary),
            ],
          ),
        ),
        body: FutureBuilder<CropInfo?>(
          future: _cropInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.neonGreen),
              );
            }

            if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text(l10n.errorLabel));
            }

            final cropInfo = snapshot.data!;
            return TabBarView(
              children: [
                CropOverviewPage(cropInfo: cropInfo),
                CropRequirementsPage(cropInfo: cropInfo),
                CropLifecyclePage(cropInfo: cropInfo),
                CropRisksPage(cropInfo: cropInfo),
                VarietyPage(cropInfo: cropInfo),
                CropSummaryPage(cropInfo: cropInfo),
              ],
            );
          },
        ),
        bottomNavigationBar: const BottomNav(),
      ),
    );
  }
}
