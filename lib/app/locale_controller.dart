import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final localeControllerProvider =
    NotifierProvider<LocaleController, Locale>(LocaleController.new);

class LocaleController extends Notifier<Locale> {
  @override
  Locale build() {
    final savedLanguage = Hive.isBoxOpen('fix_it')
        ? Hive.box<dynamic>('fix_it').get('language') as String?
        : null;
    return Locale(savedLanguage == 'ar' ? 'ar' : 'en');
  }

  Future<void> setLanguage(String languageCode) async {
    if (languageCode != 'en' && languageCode != 'ar') return;
    state = Locale(languageCode);
    if (Hive.isBoxOpen('fix_it')) {
      await Hive.box<dynamic>('fix_it').put('language', languageCode);
    }
  }
}