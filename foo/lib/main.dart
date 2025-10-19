import 'package:flutter/material.dart';
import 'app.dart';
import 'package:foo/src/services/ping.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final pingService = PingService();
  await pingService.sendPing(); //

  runApp(const MyApp());
}
