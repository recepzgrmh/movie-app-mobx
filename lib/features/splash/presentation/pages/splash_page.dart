import 'package:flutter/material.dart';
import '../../../../app/di/di.dart';
import '../stores/splash_store.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashStore store = getIt<SplashStore>();

  @override
  void initState() {
    super.initState();
    store.init();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Splash')));
  }
}
