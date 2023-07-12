import 'package:cosanostr/all_imports.dart';

// Reason to make this a custom widget is to be able to add new features
// later on. Thinking of adding a settingsscreen and profilescreen for
// example. Also, the generateKeys() function should be moved here in a
// later stage.
class ScaffoldDrawer extends StatelessWidget {
  const ScaffoldDrawer({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          const DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('CosaNostr'),
                // Bump this version every time something insanely cool is
                // added.
                Text('Version: 0.0.1'),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              // Riverpod's way of toggling a bool (I think).
              ref.read(isDarkThemeProvider.notifier).state =
                  !ref.watch(isDarkThemeProvider);
            },
            title: const Text('THEMEMODE'),
            // Check the current theme mode and display the appropriate icon.
            // Icons are up for debate, but I found these funny.
            trailing: ref.watch(isDarkThemeProvider)
                ? const Icon(FontAwesomeIcons.ghost)
                : const Icon(FontAwesomeIcons.faceFlushed),
          ),
          ListTile(
            onTap: () {
              ref.read(isThemeIndigoProvider.notifier).state =
                  !ref.watch(isThemeIndigoProvider);
            },
            title: const Text('THEMECOLOR'),
            trailing: ref.watch(isThemeIndigoProvider)
                ? const Icon(FontAwesomeIcons.droplet)
                : const Icon(FontAwesomeIcons.moneyBill),
          ),
          ListTile(
            onTap: () async {
              await ref.watch(keysExistProvider)
                  ? await ScaffoldDrawerLogic().keysExistDialog(
                      context,
                      ref,
                      ref
                          .watch(nip19Provider)
                          .npubEncode(ref.watch(publicKeyProvider)),
                      ref
                          .watch(nip19Provider)
                          .nsecEncode(ref.watch(privateKeyProvider)),
                    )
                  : ScaffoldDrawerLogic().keysOptionDialog(context, ref);
            },
            title: ref.watch(keysExistProvider)
                ? const Text('SHOW YOUR KEYS')
                : const Text('GENERATE NEW KEYS'),
            trailing: ref.watch(keysExistProvider)
                ? const Icon(FontAwesomeIcons.check)
                : const Icon(FontAwesomeIcons.plus),
          ),
          if (ref.watch(keysExistProvider))
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                await ScaffoldDrawerLogic().deleteKeysDialog(context, ref);
              },
              title: const Text('DELETE YOUR KEYS'),
              trailing: const Icon(
                FontAwesomeIcons.solidTrashCan,
                color: Colors.red,
              ),
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }
}
