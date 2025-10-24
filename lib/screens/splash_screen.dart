import 'dart:async';

import 'package:cosanostr/feedscreen_logic.dart';
import 'package:cosanostr/responsive_layout.dart';
import 'package:cosanostr/screens/onboarding/onboarding_screen.dart';
import 'package:cosanostr/signals/feedscreen_signals.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  late Timer timer;

  @override
  Future<void> initState() async {
    super.initState();
    await Future<void>.delayed(Duration.zero, () async {
      await FeedScreenLogic().getKeysFromStorage();
    }).then((_) async {
      if (sKeysExist.value && mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute<Widget>(
            builder: (BuildContext context) {
              return const ResponsiveLayout();
            },
          ),
        );
      } else {
        if (mounted) {
          await Navigator.push(
            context,
            MaterialPageRoute<Widget>(
              builder: (BuildContext context) {
                return const OnboardingScreen();
              },
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(strokeWidth: 25.0),
      ),
    );
  }
}
