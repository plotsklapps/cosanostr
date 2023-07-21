import 'dart:ui';

import 'package:cosanostr/all_imports.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<MoreScreen> createState() {
    return MoreScreenState();
  }
}

class MoreScreenState extends ConsumerState<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        scrollbars: false,
        dragDevices: <PointerDeviceKind>{
          PointerDeviceKind.touch,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
        },
      ),
      child: SingleChildScrollView(
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
                  TextButton(
                    onPressed: () async {
                      await showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return const ChangelogModal();
                        },
                      );
                    },
                    child: const Text('Version: 0.0.2'),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () async {
                if (ref.watch(keysExistProvider)) {
                  await showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return const UserExistsModal();
                    },
                  );
                } else {
                  await showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return const NewUserModal();
                    },
                  );
                }
              },
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
                onTap: () async {
                  await showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return const ConnectedRelaysModal();
                    },
                  );
                },
                title: const Text('SHOW RELAYS'),
                subtitle: const Text('Select connected relays'),
                trailing: const Icon(FontAwesomeIcons.circleNodes),
              )
            else
              const SizedBox(),
            ListTile(
              onTap: () async {
                await showModalBottomSheet<void>(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return const WtfIsNostrModal();
                  },
                );
              },
              title: const Text('WTF IS NOSTR?'),
              subtitle: const Text('About the Nostr protocol'),
              trailing: const Icon(FontAwesomeIcons.solidCircleQuestion),
            ),
            ListTile(
              onTap: () async {
                await showModalBottomSheet<void>(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return const AboutCosaNostrModal();
                  },
                );
              },
              title: const Text('ABOUT COSANOSTR'),
              subtitle: const Text('Developer info'),
              trailing: const Icon(FontAwesomeIcons.circleInfo),
            ),
            ListTile(
              onTap: () async {
                await showModalBottomSheet<void>(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return const SettingsModal();
                  },
                );
              },
              title: const Text('SETTINGS'),
              subtitle: const Text('Change the app look and feel'),
              trailing: const Icon(FontAwesomeIcons.gear),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangelogModal extends StatelessWidget {
  const ChangelogModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          scrollbars: false,
          dragDevices: <PointerDeviceKind>{
            PointerDeviceKind.touch,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.mouse,
            PointerDeviceKind.stylus,
          },
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Icon(FontAwesomeIcons.wrench),
              const SizedBox(height: 16.0),
              const Text(
                'CHANGELOG',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              const Text(
                'Version 0.0.2',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                '''
User Interface reached a form I like: Profile on the left, global feed in the middle (with personal feed coming!) and more screen on the right. Sticking with this for a while. Using simple bottomNavigationBar, but might change to Navigationbar for nicer animation. Also added confetti when adding or generating keys, to have a more successful feeling when joining CosaNostr. All AlertDialogs are now bottomModalSheets for cleaner look.''',
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Version 0.0.1',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                '''
Cherry popped! User can generate new keys or jump in with private key. Going straight to global, no profile yet. More screen just contains some settings and background info on the app. Fiddling around with Nostr protocol. This is the good stuff.''',
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
