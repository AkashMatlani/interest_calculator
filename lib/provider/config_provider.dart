import 'package:flutter/material.dart';

class ConfigProvider with ChangeNotifier {
  final Map<String, dynamic> config;

  ConfigProvider(this.config);

  Map<String, dynamic> get getConfig => config;
}
