import 'package:client_app_example/core/constants/di_constants.dart';
import 'package:client_app_example/core/constants/storage_constants.dart';
import 'package:enterprise_logger/enterprise_logger.dart';
import 'package:enterprise_storage/enterprise_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'theme_event.dart';
part 'theme_state.dart';
part 'theme_bloc.freezed.dart';

/// Owns [ThemeMode] and persists it in shared preferences.
/// @lazySingleton so the bloc is not created during configureDependencies()
/// before Hive is initialized.
@lazySingleton
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  /// Creates a [ThemeBloc] and loads saved prefs.
  ThemeBloc(
    @Named(DiConstants.hiveStorage) this._hiveStorage,
    this._logger,
  ) : super(const ThemeState.initial()) {
    on<_EventLoaded>(_onEventLoaded);
    on<_EventChanged>(_onEventChanged);
    on<_EventToggleRequested>(_onEventToggleRequested);
    on<_EventDynamicColorToggled>(_onEventDynamicColorToggled);
    on<_EventFontSizeScaled>(_onEventFontSizeScaled);
    on<_EventHighContrastToggled>(_onEventHighContrastToggled);
    on<_EventResetToDefault>(_onEventResetToDefault);

    add(const ThemeEvent.loaded());
  }

  final LocalStorage _hiveStorage;
  final LoggerService _logger;

  static const String _box = StorageConstants.settingsBox;

  Future<void> _onEventLoaded(
    _EventLoaded event,
    Emitter<ThemeState> emit,
  ) async {
    _logger.d('ThemeBloc: Loading theme preferences...');
    try {
      emit(
        state.copyWith(
          currentThemeStatus: await _getSavedThemeStatus(),
          useDynamicColor: await _getSavedDynamicColor(),
          fontSizeScale: await _getSavedFontSizeScale(),
          highContrast: await _getSavedHighContrast(),
        ),
      );
      _logger.i('ThemeBloc: Theme preferences loaded successfully');
    } on Object catch (e, stackTrace) {
      _logger.e(
        'ThemeBloc: Error loading theme preferences',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _onEventChanged(
    _EventChanged event,
    Emitter<ThemeState> emit,
  ) async {
    _logger.i('ThemeBloc: Changing theme to ${event.themeMode}');
    try {
      await _saveThemeStatus(event.themeMode);
      emit(state.copyWith(currentThemeStatus: event.themeStatus));
    } on Object catch (e, stackTrace) {
      _logger.e(
        'ThemeBloc: Error saving theme',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _onEventToggleRequested(
    _EventToggleRequested event,
    Emitter<ThemeState> emit,
  ) async {
    add(
      ThemeEvent.changed(
        themeStatus: _getNextThemeStatus(state.currentThemeStatus),
      ),
    );
  }

  Future<void> _onEventDynamicColorToggled(
    _EventDynamicColorToggled event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      // deriving the app palette from the device wallpaper / system colors
      await _write(StorageConstants.dynamicColor, event.enabled);
      emit(state.copyWith(useDynamicColor: event.enabled));
    } on Object catch (error, stackTrace) {
      _logger.e(
        'ThemeBloc: Error saving dynamic color',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _onEventFontSizeScaled(
    _EventFontSizeScaled event,
    Emitter<ThemeState> emit,
  ) async {
    final clampedScale = event.scale.clamp(0.8, 1.5);
    try {
      await _write(StorageConstants.fontSizeScale, clampedScale);
      emit(state.copyWith(fontSizeScale: clampedScale));
    } on Object catch (error, stackTrace) {
      _logger.e(
        'ThemeBloc: Error saving font size scale',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _onEventHighContrastToggled(
    _EventHighContrastToggled event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      await _write(StorageConstants.highContrast, event.enabled);
      emit(state.copyWith(highContrast: event.enabled));
    } on Object catch (error, stackTrace) {
      _logger.e(
        'ThemeBloc: Error saving high contrast',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _onEventResetToDefault(
    _EventResetToDefault event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      await _hiveStorage.delete(StorageConstants.themeMode, boxName: _box);
      await _hiveStorage.delete(StorageConstants.dynamicColor, boxName: _box);
      await _hiveStorage.delete(StorageConstants.fontSizeScale, boxName: _box);
      await _hiveStorage.delete(StorageConstants.highContrast, boxName: _box);
      emit(const ThemeState.initial());
    } on Object catch (error, stackTrace) {
      _logger.e(
        'ThemeBloc: Error resetting to default',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      _logger.i('ThemeBloc: Reset to default completed');
    }
  }

  AppThemeStatus _getNextThemeStatus(AppThemeStatus current) =>
      switch (current) {
        AppThemeStatus.light => AppThemeStatus.dark,
        AppThemeStatus.dark => AppThemeStatus.system,
        AppThemeStatus.system => AppThemeStatus.light,
      };

  Future<AppThemeStatus> _getSavedThemeStatus() async {
    final themeString = await _hiveStorage.read<String>(
      StorageConstants.themeMode,
      boxName: _box,
    );
    if (themeString == null) return AppThemeStatus.system;
    return AppThemeStatus.values.firstWhere(
      (e) => e.toString() == themeString,
      orElse: () => AppThemeStatus.system,
    );
  }

  Future<bool> _getSavedDynamicColor() async =>
      await _hiveStorage.read<bool>(
        StorageConstants.dynamicColor,
        boxName: _box,
      ) ??
      false;

  Future<double> _getSavedFontSizeScale() async =>
      await _hiveStorage.read<double>(
        StorageConstants.fontSizeScale,
        boxName: _box,
      ) ??
      1.0;

  Future<bool> _getSavedHighContrast() async =>
      await _hiveStorage.read<bool>(
        StorageConstants.highContrast,
        boxName: _box,
      ) ??
      false;

  Future<void> _saveThemeStatus(AppThemeStatus themeStatus) =>
      _write(StorageConstants.themeMode, themeStatus.toString());

  Future<void> _write(String key, Object value) =>
      _hiveStorage.write(key, value, boxName: _box);
}
