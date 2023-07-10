import 'package:cosanostr/all_imports.dart';

class ScaffoldScreen extends ConsumerStatefulWidget {
  const ScaffoldScreen({super.key});

  @override
  ConsumerState<ScaffoldScreen> createState() {
    return _ScaffoldScreenState();
  }
}

class _ScaffoldScreenState extends ConsumerState<ScaffoldScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CosaNostrAppBar(
        title: 'CosaNostr',
        isConnected: ref.watch(isConnectedProvider),
      ),
      drawer: const Drawer(),
      body: const ResponsiveLayout(),
    );
  }
}
