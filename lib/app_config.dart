import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  final int maxDiceNumber;

  AppConfig({required this.maxDiceNumber});

  static Future<AppConfig> forEnvironment() async {
    final contents = await rootBundle.loadString(
      'assets/config/app_settings.json',
    );

    final json = jsonDecode(contents);
    var result = json['maxDiceNumber'];

    return AppConfig(maxDiceNumber: result);
  }
}
