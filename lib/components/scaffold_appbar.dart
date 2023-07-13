import 'package:cosanostr/all_imports.dart';

// Reason to make this a custom widget is to be able to add new features
// later on. For example, a search bar or a notification icon.
class ScaffoldAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ScaffoldAppBar({super.key});

  @override
  Size get preferredSize {
    return const Size.fromHeight(50);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('CosaNostr'),
      centerTitle: true,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Icon(
            // Use the isConnectedProvider and isDarkThemeProvider to get
            // the current connection status and themeMode to
            // display the appropriate icon.
            ref.watch(isConnectedProvider)
                ? FontAwesomeIcons.solidCircleCheck
                : FontAwesomeIcons.circleMinus,
          ),
        ),
      ],
    );
  }
}
