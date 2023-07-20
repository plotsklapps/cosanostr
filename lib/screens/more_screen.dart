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
                  const Text('Version: 0.0.1'),
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
