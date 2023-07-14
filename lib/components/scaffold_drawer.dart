import 'package:cosanostr/all_imports.dart';

// Reason to make this a custom widget is to be able to add new features
// later on. Thinking of adding a settingsscreen and profilescreen for
// example.
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
            onTap: () async {
              // Check if keys are already generated and display the
              // appropriate dialog.
              if (ref.watch(keysExistProvider)) {
                await Dialogs().keysExistDialog(
                  context,
                  ref,
                  ref
                      .watch(nip19Provider)
                      .npubEncode(ref.watch(publicKeyProvider)),
                  ref
                      .watch(nip19Provider)
                      .nsecEncode(ref.watch(privateKeyProvider)),
                );
              } else {
                await Dialogs().keysOptionDialog(context, ref);
              }
            },
            // Check if keys are already generated and display the
            // appropriate title and icon.
            title: ref.watch(keysExistProvider)
                ? const Text('SHOW YOUR KEYS')
                : const Text('GENERATE NEW KEYS'),
            trailing: ref.watch(keysExistProvider)
                ? const Icon(FontAwesomeIcons.check)
                : const Icon(FontAwesomeIcons.plus),
          ),
          // Check if keys are already generated and display this ListTile
          // only if they are.
          if (ref.watch(keysExistProvider))
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                await Dialogs().deleteKeysDialog(context, ref);
              },
              title: const Text('DELETE YOUR KEYS'),
              trailing: const Icon(
                FontAwesomeIcons.solidTrashCan,
                color: Colors.red,
              ),
            )
          else
            const SizedBox(),
          ListTile(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<Widget>(
                  builder: (BuildContext context) {
                    return const AboutScreen();
                  },
                ),
              );
            },
            title: const Text('ABOUT'),
            // Check the current theme mode and display the appropriate icon.
            // Icons are up for debate, but I found these funny.
            trailing: const Icon(FontAwesomeIcons.circleInfo),
          ),
          ListTile(
            onTap: () async {
              Navigator.pop(context);
              await Dialogs().settingsDialog(context, ref);
            },
            title: const Text('SETTINGS'),
            trailing: const Icon(FontAwesomeIcons.gear),
          ),
        ],
      ),
    );
  }
}
