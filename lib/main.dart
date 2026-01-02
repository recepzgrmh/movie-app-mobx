import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/di/di.dart';

void main() {
  configureDependencies();
  runApp(const App());
}
