import 'dart:ui';

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
            onTap: () {
              ref.read(isFontQuestrialProvider.notifier).state =
                  !ref.watch(isFontQuestrialProvider);
            },
            title: const Text('THEMEFONT'),
            trailing: ref.watch(isFontQuestrialProvider)
                ? const Icon(FontAwesomeIcons.quora)
                : const Icon(FontAwesomeIcons.bold),
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
        ],
      ),
    );
  }
}

Future<void> buildShowDonationsDialog(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(
            scrollbars: false,
            dragDevices: <PointerDeviceKind>{
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
            },
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Donations 💙',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                const Text(
                  """
CosaNostr is proudly developed and maintained by a solo developer, committed to providing you a free and ad-free experience. That's a promise! Your support goes a long way in helping me keep this promise and continue to improve the app. If you find value in what I do, please consider making a donation. You can opt for a one-time donation or choose a recurring monthly membership. Your generosity is deeply appreciated. Thank you!""",
                  textAlign: TextAlign.center,
                ),
                const Divider(),
                ElevatedButton(
                  onPressed: () async {
                    await HttpUtils().launchOneTimeDonationStripe();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.stripe),
                      SizedBox(width: 16),
                      Text('One-time donation (free amount)'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    await HttpUtils().launchMonthlySubscriptionStripe();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.stripe),
                      SizedBox(width: 16),
                      Text('Monthly subscription (€ 3.00)'),
                    ],
                  ),
                ),
                const Divider(),
                const Text(
                  '''
You can also scan the QR-code with your mobile phone to make a donation''',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('One-time'),
                        Image.asset(
                          'assets/images/onetime_qr.png',
                          height: MediaQuery.sizeOf(context).height * 0.2,
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Monthly'),
                        Image.asset(
                          'assets/images/monthly_qr.png',
                          height: MediaQuery.sizeOf(context).height * 0.2,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  child: const Text('Not now'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
