import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/colors.dart';
import '../utils/routers.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      context.goNamed(welcomeRoute);
    }
  }

  @override
  void initState() {
    super.initState();

    navigate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primary,
      body: Center(
        child: CircularProgressIndicator(backgroundColor: Colors.white),
      ),
    );
  }
}
