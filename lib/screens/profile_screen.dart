import 'package:cosanostr/all_imports.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: Column(
              children: [
                Row(
                  children: [
                    Image.network(''),
                    Text('TEST'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
