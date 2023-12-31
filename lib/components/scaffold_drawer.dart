import 'package:cosanostr/all_imports.dart';

// Reason to make this a custom widget is to be able to add new features
// later on. Thinking of adding a settingsscreen and profilescreen for
// example.
class ScaffoldDrawer extends ConsumerWidget {
  const ScaffoldDrawer(
    this.currentContext,
    this.ref, {
    super.key,
  });

  final BuildContext currentContext;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  child: ref.watch(isDarkThemeProvider)
                      ? Image.asset('assets/images/cosanostr_white_icon.png')
                      : Image.asset('assets/images/cosanostr_black_icon.png'),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'CosaNostr',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                // Bump this version every time something insanely cool is
                // added.
                const Text('Version: 0.0.1'),
              ],
            ),
          ),
          ListTile(
            onTap: () async {
              // Check if keys are already generated and display the
              // appropriate dialog.
              // if (ref.watch(keysExistProvider)) {
              //   await showKeysExistDialog(
              //     ref,
              //     ref
              //         .watch(nip19Provider)
              //         .npubEncode(ref.watch(publicKeyProvider)),
              //     ref
              //         .watch(nip19Provider)
              //         .nsecEncode(ref.watch(privateKeyProvider)),
              //   );
              // } else {
              //   // await showKeysOptionsDialog(currentContext, ref).then((_) {
              //   //   Navigator.pop(context);
              //   // });
              // }
            },
            // Check if keys are already generated and display the
            // appropriate title and icon.
            title: ref.watch(keysExistProvider)
                ? const Text('SHOW YOUR KEYS')
                : const Text('GENERATE NEW KEYS'),
            subtitle: ref.watch(keysExistProvider)
                ? const Text('Your keys are securely stored')
                : const Text('Join the CosaNostr client'),
            trailing: ref.watch(keysExistProvider)
                ? const Icon(FontAwesomeIcons.check)
                : const Icon(FontAwesomeIcons.plus),
          ),
          if (ref.watch(keysExistProvider))
            ListTile(
              onTap: () async {},
              title: const Text('SHOW RELAYS'),
              subtitle: const Text('Select connected relays'),
              trailing: const Icon(FontAwesomeIcons.circleNodes),
            )
          else
            const SizedBox(),
          ListTile(
            onTap: () async {
              //Create an alertdialog or bottomsheet with explanation about
              // the Nostr protocol. Why and how, maybe embed the Youtube
              // doc from deMarco? For now:
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                ScaffoldSnackBar(
                  context: context,
                  content: const Text('Coming soon!'),
                ),
              );
            },
            title: const Text('WTF IS NOSTR?'),
            subtitle: const Text('About the Nostr protocol'),
            trailing: const Icon(FontAwesomeIcons.solidCircleQuestion),
          ),
          ListTile(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<Widget>(
                  builder: (BuildContext context) {
                    return const Placeholder();
                  },
                ),
              );
            },
            title: const Text('ABOUT COSANOSTR'),
            subtitle: const Text('Developer info'),
            trailing: const Icon(FontAwesomeIcons.circleInfo),
          ),
          ListTile(
            onTap: () async {
              Navigator.pop(context);
            },
            title: const Text('SETTINGS'),
            subtitle: const Text('Change the app look and feel'),
            trailing: const Icon(FontAwesomeIcons.gear),
          ),
        ],
      ),
    );
  }
}
