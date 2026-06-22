import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'formatters.dart';

class AppSettings {
  final ThemeMode themeMode;
  final String currencySymbol;
  final String locale;

  /// Optional remote endpoint returning a JSON map of indicative rates.
  final String ratesEndpoint;

  /// Customizable source labels for transactions
  final String autoLabel;
  final String emiLabel;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.currencySymbol = '\u20B9',
    this.locale = 'en_IN',
    this.ratesEndpoint = '',
    this.autoLabel = 'Auto',
    this.emiLabel = 'EMI',
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? currencySymbol,
    String? locale,
    String? ratesEndpoint,
    String? autoLabel,
    String? emiLabel,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      locale: locale ?? this.locale,
      ratesEndpoint: ratesEndpoint ?? this.ratesEndpoint,
      autoLabel: autoLabel ?? this.autoLabel,
      emiLabel: emiLabel ?? this.emiLabel,
    );
  }
}

/// Set during bootstrap so the notifier can read/write synchronously.
final sharedPrefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Override in main()'),
);

class SettingsNotifier extends Notifier<AppSettings> {
  static const _kTheme = 'themeMode';
  static const _kSymbol = 'currencySymbol';
  static const _kLocale = 'locale';
  static const _kRates = 'ratesEndpoint';
  static const _kAutoLabel = 'autoLabel';
  static const _kEmiLabel = 'emiLabel';

  SharedPreferences get _prefs => ref.read(sharedPrefsProvider);

  @override
  AppSettings build() {
    final p = _prefs;
    final s = AppSettings(
      themeMode: ThemeMode.values[p.getInt(_kTheme) ?? ThemeMode.system.index],
      currencySymbol: p.getString(_kSymbol) ?? '\u20B9',
      locale: p.getString(_kLocale) ?? 'en_IN',
      ratesEndpoint: p.getString(_kRates) ?? '',
      autoLabel: p.getString(_kAutoLabel) ?? 'Auto',
      emiLabel: p.getString(_kEmiLabel) ?? 'EMI',
    );
    _applyGlobals(s);
    return s;
  }

  void _applyGlobals(AppSettings s) {
    Money.symbol = s.currencySymbol;
    Money.locale = s.locale;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setInt(_kTheme, mode.index);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setCurrency(String symbol, String locale) async {
    await _prefs.setString(_kSymbol, symbol);
    await _prefs.setString(_kLocale, locale);
    state = state.copyWith(currencySymbol: symbol, locale: locale);
    _applyGlobals(state);
  }

  Future<void> setRatesEndpoint(String url) async {
    await _prefs.setString(_kRates, url);
    state = state.copyWith(ratesEndpoint: url);
  }

  Future<void> setAutoLabel(String label) async {
    await _prefs.setString(_kAutoLabel, label);
    state = state.copyWith(autoLabel: label);
  }

  Future<void> setEmiLabel(String label) async {
    await _prefs.setString(_kEmiLabel, label);
    state = state.copyWith(emiLabel: label);
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
