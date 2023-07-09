import 'package:cosanostr/all_imports.dart';

void main() {
  runApp(const MainEntry());
}

class MainEntry extends StatelessWidget {
  const MainEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noost',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
      ),
      home: const NoostFeedScreen(),
    );
  }
}
