import 'dart:ui';

import 'package:cosanostr/all_imports.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DrawerHeader(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(UtilsString.kPlotsklappsLogoStraight),
            ),
          ),
          const Text(
            UtilsString.kTimelappsByPlotsklapps,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              UtilsString.kEnjoyedMakingIt,
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(),
          // Button to open plotsklapps website.
          ElevatedButton(
            onPressed: () async {
              await UtilsHttp().launchWebsite();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(FontAwesomeIcons.houseChimney),
                SizedBox(width: 16),
                Text(UtilsString.kWebsite),
              ],
            ),
          )
              .animate()
              .fade(delay: 0.ms, duration: 1000.ms)
              .move(delay: 0.ms, duration: 1000.ms),
          const SizedBox(height: 8),
          // Button to open source code on GitHub.
          ElevatedButton(
            onPressed: () async {
              await UtilsHttp().launchSourceCode();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(FontAwesomeIcons.code),
                SizedBox(width: 16),
                Text(UtilsString.kSourceCode),
              ],
            ),
          )
              .animate()
              .fade(delay: 500.ms, duration: 1000.ms)
              .move(delay: 500.ms, duration: 1000.ms),
          const SizedBox(height: 8),
          // Button to show the bottomsheet for donations.
          ElevatedButton(
            onPressed: () async {
              await buildShowDonationsDialog(context);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(FontAwesomeIcons.heartCircleCheck),
                SizedBox(width: 16),
                Text(UtilsString.kDonate),
              ],
            ),
          )
              .animate()
              .fade(delay: 1000.ms, duration: 1000.ms)
              .move(delay: 1000.ms, duration: 1000.ms),
          const SizedBox(height: 8),
          // Button to show the bottomsheet with app related content, like
          // packages used.
          ElevatedButton(
            onPressed: () async {
              await buildShowAboutDialog(context);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(FontAwesomeIcons.circleInfo),
                SizedBox(width: 16),
                Text(UtilsString.kAbout),
              ],
            ),
          )
              .animate()
              .fade(delay: 1500.ms, duration: 1000.ms)
              .move(delay: 1500.ms, duration: 1000.ms),
          const Divider(),
        ],
      ),
    );
  }

  Future<void> buildShowAboutDialog(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  UtilsString.kAbout,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                const Text(
                  UtilsString.kPackages,
                  textAlign: TextAlign.center,
                ),
                const Divider(),
                ElevatedButton(
                  onPressed: () async {
                    await UtilsHttp().launchFlutterRiverpod();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.database),
                      SizedBox(width: 16),
                      Text(UtilsString.kRiverpod),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    await UtilsHttp().launchFlexColorScheme();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.paintRoller),
                      SizedBox(width: 16),
                      Text(UtilsString.kFlexColorScheme),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    await UtilsHttp().launchFlutterAnimate();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.arrowsUpDownLeftRight),
                      SizedBox(width: 16),
                      Text(UtilsString.kFlutterAnimate),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    await UtilsHttp().launchJustAudio();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.music),
                      SizedBox(width: 16),
                      Text(UtilsString.kJustAudio),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                    UtilsString.kDonations,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  const Text(
                    UtilsString.kDonationsPlease,
                    textAlign: TextAlign.center,
                  ),
                  const Divider(),
                  ElevatedButton(
                    onPressed: () async {
                      await UtilsHttp().launchOneTimeDonationStripe();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.stripe),
                        SizedBox(width: 16),
                        Text(UtilsString.kOneTimeDonation),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await UtilsHttp().launchMonthlySubscriptionStripe();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.stripe),
                        SizedBox(width: 16),
                        Text(UtilsString.kMonthlySubscription),
                      ],
                    ),
                  ),
                  const Divider(),
                  const Text(
                    UtilsString.kDonateViaPhone,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('One-time'),
                          Image.asset(UtilsString.kOneTimeQR,
                              height: MediaQuery.sizeOf(context).height * 0.2),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('Monthly'),
                          Image.asset(UtilsString.kMonthlyQR,
                              height: MediaQuery.sizeOf(context).height * 0.2),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    child: const Text(UtilsString.kNotNow),
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
}
