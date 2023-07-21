import 'package:cosanostr/all_imports.dart';

Future<void> main() async {
  // Mandatory Firebase stuff. JUST FOR ANALYTICS, nothing else.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    // ProviderScope is mandatory for Riverpod to work.
    const ProviderScope(
      child: MainEntry(),
    ),
  );
}

class MainEntry extends ConsumerWidget {
  const MainEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CosaNostr - NOSTR Client by PLOTSKLAPPS',
      // Use Riverpod Providers to get the current theme and theme mode.
      theme: ref.watch(lightThemeProvider),
      darkTheme: ref.watch(darkThemeProvider),
      themeMode: ref.watch(themeModeProvider),
      // This is a first draft for responsiveness. Will be improved later.
      home: OnboardingScreen(),
    );
  }
}
