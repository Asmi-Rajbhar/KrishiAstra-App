part of 'scanner_bloc.dart';

abstract class ScannerEvent extends Equatable {
  const ScannerEvent();

  @override
  List<Object?> get props => [];
}

class InitializeCamera extends ScannerEvent {}

class CaptureAndAnalyze extends ScannerEvent {
  final String imagePath;
  const CaptureAndAnalyze(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class ResetScanner extends ScannerEvent {}
