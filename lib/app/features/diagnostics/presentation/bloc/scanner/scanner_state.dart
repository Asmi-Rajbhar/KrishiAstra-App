part of 'scanner_bloc.dart';

abstract class ScannerState extends Equatable {
  const ScannerState();

  @override
  List<Object?> get props => [];
}

class ScannerInitial extends ScannerState {}

class ScannerLoading extends ScannerState {}

class CameraReady extends ScannerState {}

class ScannerSuccess extends ScannerState {
  final Disease? disease;
  const ScannerSuccess(this.disease);

  @override
  List<Object?> get props => [disease];
}

class ScannerFailure extends ScannerState {
  final String message;
  const ScannerFailure(this.message);

  @override
  List<Object?> get props => [message];
}
