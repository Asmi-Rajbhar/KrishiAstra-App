import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/bloc/scanner/scanner_bloc.dart';
import 'package:krishiastra/app/core/navigation/app_router.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/utils/l10n_helper.dart';

class PlantScannerPage extends StatefulWidget {
  const PlantScannerPage({super.key});

  @override
  State<PlantScannerPage> createState() => _PlantScannerPageState();
}

class _PlantScannerPageState extends State<PlantScannerPage>
    with SingleTickerProviderStateMixin {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  final ImagePicker _picker = ImagePicker();

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Initialize the global ScannerBloc
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ScannerBloc>().add(InitializeCamera());
      }
    });
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      try {
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      } catch (e) {
        if (kDebugMode) debugPrint('Camera initialization error: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _captureAndAnalyze(BuildContext context) async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final XFile image = await _controller!.takePicture();
      if (context.mounted) {
        context.read<ScannerBloc>().add(CaptureAndAnalyze(image.path));
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error taking picture: $e');
    }
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null && context.mounted) {
        context.read<ScannerBloc>().add(CaptureAndAnalyze(image.path));
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error picking from gallery: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScannerBloc, ScannerState>(
      listener: (context, state) {
        if (state is ScannerSuccess) {
          if (state.disease != null) {
            Navigator.pushReplacementNamed(
              context,
              AppRouter.diagnosticDetail,
              arguments: state.disease,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.scannerQualityHint),
              ),
            );
          }
        } else if (state is ScannerFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${AppLocalizations.of(context)!.errorLabel} ${L10nHelper.getLocalizedMessage(context, state.message)}",
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Camera Preview
              if (_isCameraInitialized && _controller != null)
                Positioned.fill(
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: CameraPreview(_controller!),
                  ),
                )
              else
                const Center(child: CircularProgressIndicator()),

              // Overlay / Target Frame
              _buildOverlay(context, state),

              // AI Status Header
              _buildHeader(context, state),

              // Controls
              _buildControls(context, state),

              // Back Button
              Positioned(
                top: MediaQuery.of(context).padding.top + AppSizes.sm,
                left: AppSizes.md,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMax),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      AppIcons.arrowBack,
                      color: Colors.white,
                      size: AppSizes.iconMd,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ScannerState state) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + AppSizes.md,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(AppSizes.radiusMax),
            border: Border.all(
              color: AppColors.neonGreen.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                AppIcons.healthAndSafety,
                color: AppColors.neonGreen,
                size: AppSizes.iconSm,
              ),
              const SizedBox(width: AppSizes.xs),
              Text(
                state is ScannerLoading
                    ? AppLocalizations.of(context)!.aiAnalyzing
                    : AppLocalizations.of(context)!.aiPlantDoctor,
                style: const TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.fontCaption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context, ScannerState state) {
    const size = 280.0;
    return IgnorePointer(
      child: Stack(
        children: [
          // Semi-transparent background with a hole
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.5),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Center(
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scanning Line and Frame
          Center(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                border: Border.all(
                  color: state is ScannerLoading
                      ? AppColors.neonGreen
                      : Colors.white24,
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: Stack(
                children: [
                  // Scanning Line Animation
                  if (state is ScannerLoading)
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Positioned(
                          top: _animation.value * (size - 4),
                          left: 2,
                          right: 2,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.neonGreen.withValues(alpha: 0),
                                  AppColors.neonGreen,
                                  AppColors.neonGreen.withValues(alpha: 0),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.neonGreen.withValues(
                                    alpha: 0.5,
                                  ),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  // Corner markers
                  _buildCorner(top: 0, left: 0),
                  _buildCorner(top: 0, right: 0),
                  _buildCorner(bottom: 0, left: 0),
                  _buildCorner(bottom: 0, right: 0),

                  // Hint text when not loading
                  if (state is! ScannerLoading)
                    Positioned(
                      bottom: AppSizes.md,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.fitPlantInFrame,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: AppSizes.fontCaption,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner({
    double? top,
    double? left,
    double? right,
    double? bottom,
  }) {
    const double length = 40.0;
    const double thickness = 4.0;
    const double radius = AppSizes.radiusLg;

    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: length,
        height: length,
        decoration: BoxDecoration(
          border: Border(
            top: top != null
                ? const BorderSide(color: AppColors.neonGreen, width: thickness)
                : BorderSide.none,
            bottom: bottom != null
                ? const BorderSide(color: AppColors.neonGreen, width: thickness)
                : BorderSide.none,
            left: left != null
                ? const BorderSide(color: AppColors.neonGreen, width: thickness)
                : BorderSide.none,
            right: right != null
                ? const BorderSide(color: AppColors.neonGreen, width: thickness)
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: top != null && left != null
                ? const Radius.circular(radius)
                : Radius.zero,
            topRight: top != null && right != null
                ? const Radius.circular(radius)
                : Radius.zero,
            bottomLeft: bottom != null && left != null
                ? const Radius.circular(radius)
                : Radius.zero,
            bottomRight: bottom != null && right != null
                ? const Radius.circular(radius)
                : Radius.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context, ScannerState state) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Column(
        children: [
          if (state is ScannerLoading)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.lg),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.lg,
                  vertical: AppSizes.sm,
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMax),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonGreen.withValues(alpha: 0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.neonGreen,
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.aiAnalyzing,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: AppSizes.fontBody,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.identifyingDisease,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          if (state is ScannerFailure)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.lg),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.sm,
                ),
                margin: const EdgeInsets.symmetric(horizontal: AppSizes.xl * 2),
                decoration: BoxDecoration(
                  color: AppColors.redShade.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: Text(
                            L10nHelper.getLocalizedMessage(
                              context,
                              state.message,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: AppSizes.fontCaption,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.sm),
                    TextButton(
                      onPressed: () {
                        context.read<ScannerBloc>().add(ResetScanner());
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSm,
                          ),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.retryScan,
                        style: const TextStyle(
                          color: AppColors.redShade,
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.fontCaption,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSideButton(
                icon: AppIcons.photoLibrary,
                onPressed: state is ScannerLoading
                    ? null
                    : () => _pickFromGallery(context),
              ),
              _buildCaptureButton(context, state),
              _buildSideButton(
                icon: AppIcons.info,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.aiScannerTip),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSideButton({required IconData icon, VoidCallback? onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black38,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: AppSizes.iconMd),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCaptureButton(BuildContext context, ScannerState state) {
    final bool isLoading = state is ScannerLoading;
    return GestureDetector(
      onTap: isLoading ? null : () => _captureAndAnalyze(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isLoading ? AppColors.neonGreen : Colors.white,
            width: 4,
          ),
        ),
        child: Center(
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: isLoading
                  ? AppColors.neonGreen.withValues(alpha: 0.5)
                  : Colors.white,
              shape: BoxShape.circle,
            ),
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
