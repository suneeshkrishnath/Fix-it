import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:fix_it/app/locale_controller.dart';

void main() {
  late Directory directory;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('fix_it_locale_');
    Hive.init(directory.path);
    await Hive.openBox<dynamic>('fix_it');
  });

  tearDown(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  test('English is the default language', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(localeControllerProvider), const Locale('en'));
  });

  test('selected language is restored from Hive', () async {
    final firstContainer = ProviderContainer();
    await firstContainer
        .read(localeControllerProvider.notifier)
        .setLanguage('ar');
    firstContainer.dispose();

    final restoredContainer = ProviderContainer();
    addTearDown(restoredContainer.dispose);

    expect(restoredContainer.read(localeControllerProvider), const Locale('ar'));
  });
}