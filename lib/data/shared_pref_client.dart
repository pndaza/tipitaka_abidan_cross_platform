
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/word_repo.dart';

const _keyIsInitialized = 'is_initialized';
const _defaultIsInitialized = false;

const _keyDatabaseVersion = 'database_version';
const _defaultDatabaseVersion = 0;

const _keyFontSize = 'font_size';
const _defaultFontSize = 18.0;

const _keyThemeModeIndex = 'theme_mode_index';
const _defaultThemeModeIndex = 0; // ThemeMode.system

const _keyPdfThemeModeIndex = 'pdf_theme_mode_index';
const _defaultPdfThemeModeIndex = 0; // ColorMode.day

const _keyScrollDirection = 'scroll_direction';
// const _defaultScrollDirectionIndex = Axis.vertical.index;

const _keySearchMode = 'search_mode';
// const _defaultSearchModeIndex = SearchMode.prefix.index;

const _keyRecents = 'recents';
const String _defaultRecents = '';

const _keyFavourites = 'favourites';
const String _defaultFavourites = '';

class SharedPreferenceClient {
  SharedPreferenceClient._();
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  static bool get isInitialized =>
      instance.getBool(_keyIsInitialized) ?? _defaultIsInitialized;
  static set isInitialized(bool value) =>
      instance.setBool(_keyIsInitialized, value);

  static int get databaseVerion =>
      instance.getInt(_keyDatabaseVersion) ?? _defaultDatabaseVersion;
  static set databaseVerion(int value) =>
      instance.setInt(_keyDatabaseVersion, value);

  static double get fontSize =>
      instance.getDouble(_keyFontSize) ?? _defaultFontSize;
  static set fontSize(double value) => instance.setDouble(_keyFontSize, value);

  static int get themeModeIndex =>
      instance.getInt(_keyThemeModeIndex) ?? _defaultThemeModeIndex;
  static set themeModeIndex(int value) =>
      instance.setInt(_keyThemeModeIndex, value);

  static int get pdfThemeModeIndex =>
      instance.getInt(_keyPdfThemeModeIndex) ?? _defaultPdfThemeModeIndex;
  static set pdfThemeModeIndex(int value) =>
      instance.setInt(_keyPdfThemeModeIndex, value);

  static int get scrollDirectionIndex =>
      instance.getInt(_keyScrollDirection) ?? Axis.vertical.index;
  static set scrollDirectionIndex(int value) =>
      instance.setInt(_keyScrollDirection, value);

  static int get searchModeIndex =>
      instance.getInt(_keySearchMode) ?? SearchMode.prefix.index;
  static set searchModeIndex(int value) =>
      instance.setInt(_keySearchMode, value);

  static String get recents =>
      instance.getString(_keyRecents) ?? _defaultRecents;
  static set recents(String value) => instance.setString(_keyRecents, value);

  static String get favourites =>
      instance.getString(_keyFavourites) ?? _defaultFavourites;
  static set favourites(String value) => instance.setString(_keyFavourites, value);
}
