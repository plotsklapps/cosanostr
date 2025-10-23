import 'package:cosanostr/all_imports.dart';
import 'package:cosanostr/signals/theme_signals.dart';
import 'package:signals/signals_flutter.dart';

Future<void> main() async {
  // Mandatory Firebase stuff. JUST FOR ANALYTICS, nothing else.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainEntry());
}

class MainEntry extends ConsumerWidget {
  const MainEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CosaNostr - NOSTR Client by PLOTSKLAPPS',
      theme: cThemeData.watch(context),
      // This is a first draft for responsiveness. Will be improved later.
      home: const SplashScreen(),
    );
  }
}
