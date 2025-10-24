import 'package:cosanostr/signals/feedscreen_signals.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals/signals_flutter.dart';

// Reason to make this a custom widget is to be able to add new features
// later on. For example, a search bar or a notification icon.
class ScaffoldAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ScaffoldAppBar({super.key});

  @override
  Size get preferredSize {
    return const Size.fromHeight(40);
  }

  @override
  Widget build(BuildContext context) {
    final bool isConnected = sConnected.watch(context);

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
            isConnected
                ? FontAwesomeIcons.solidCircleCheck
                : FontAwesomeIcons.circleMinus,
          ),
        ),
      ],
    );
  }
}
