import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum LanguageStatus { initial, downloading, ready, error }

class LanguageState extends Equatable {
  final Locale locale;
  final LanguageStatus status;
  final String? errorMessage;

  const LanguageState({
    this.locale = const Locale('en'),
    this.status = LanguageStatus.ready,
    this.errorMessage,
  });

  LanguageState copyWith({
    Locale? locale,
    LanguageStatus? status,
    String? errorMessage,
  }) {
    return LanguageState(
      locale: locale ?? this.locale,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [locale, status, errorMessage];
}
