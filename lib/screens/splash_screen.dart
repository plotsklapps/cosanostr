import 'dart:async';

import 'package:cosanostr/all_imports.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration.zero, () async {
      await FeedScreenLogic().getKeysFromStorage(ref);
    }).then((_) async {
      if (ref.watch(keysExistProvider)) {
        await Navigator.push(
          context,
          MaterialPageRoute<Widget>(
            builder: (BuildContext context) {
              return const ResponsiveLayout();
            },
          ),
        );
      } else {
        await Navigator.push(
          context,
          MaterialPageRoute<Widget>(
            builder: (BuildContext context) {
              return const OnboardingScreen();
            },
          ),
        );
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
