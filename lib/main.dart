import 'package:cosanostr/all_imports.dart';

import 'firebase_options.dart';

Future<void> main() async {
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
      title: 'CosaNostr',
      // Use Riverpod Providers to get the current theme and theme mode.
      theme: ref.watch(lightThemeProvider),
      darkTheme: ref.watch(darkThemeProvider),
      themeMode: ref.watch(themeModeProvider),
      // This is a first draft for responsiveness. Will be improved later.
      home: const ResponsiveLayout(),
    );
  }
}
