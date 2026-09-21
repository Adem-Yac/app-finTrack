import 'package:fintrack/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    initializeDateFormatting('fr'),
    initializeDateFormatting('ar'),
    initializeDateFormatting('en'),
  ]);
  runApp(const FinTrackApp());
}
