import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<dynamic>('fix_it');
  await Hive.openBox<dynamic>('service_requests');
  await Hive.openBox<dynamic>('move_out_requests');
  runApp(const ProviderScope(child: FixItApp()));
}