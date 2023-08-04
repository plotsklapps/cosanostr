import 'dart:ui';

import 'package:cosanostr/all_imports.dart';

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
                'Version 0.0.3',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                '''Sticking to the UI layout for now. Desktop version now has better use of screensize, onboarding added for new visitors to cosanostr.app. Onboarding now works as it should, but it will receive a UI overhaul soon. Still working on NIP fetching for profile and reactions.''',
              ),
              const SizedBox(height: 8.0),
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
