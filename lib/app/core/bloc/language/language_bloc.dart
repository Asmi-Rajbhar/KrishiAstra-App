import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  static const String _key = 'language_code';

  LanguageBloc() : super(const LanguageState()) {
    on<LoadLanguage>(_onLoadLanguage);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onLoadLanguage(
    LoadLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? langCode = prefs.getString(_key);
    if (langCode != null) {
      emit(
        state.copyWith(locale: Locale(langCode), status: LanguageStatus.ready),
      );
    }
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    if (event.locale == state.locale) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, event.locale.languageCode);

    emit(state.copyWith(locale: event.locale, status: LanguageStatus.ready));
  }
}
