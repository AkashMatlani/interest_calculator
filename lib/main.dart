import 'package:flutter/material.dart';
import 'package:interest_calculator/widgets/interest_form.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'provider/config_provider.dart';
import 'provider/form_state_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = await loadConfig();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConfigProvider(config)),
        ChangeNotifierProvider(create: (_) => FormStateProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<Map<String, dynamic>> loadConfig() async {
  final configString = await rootBundle.loadString('assets/config.json');
  return json.decode(configString);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compound Interest Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InterestForm(),
    );
  }
}
