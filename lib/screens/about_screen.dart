import 'dart:ui';

import 'package:cosanostr/all_imports.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DrawerHeader(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.asset('assets/images/plotsklapps_straight.png'),
                ),
              ),
              const Text(
                StringUtils.kCosaNostraByPlotsklapps,
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
                  StringUtils.kEnjoyedMakingIt,
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(),
              // Button to open plotsklapps website.
              ElevatedButton(
                onPressed: () async {
                  await HttpUtils().launchWebsite();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.houseChimney),
                    SizedBox(width: 16),
                    Text(StringUtils.kWebsite),
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
                  await HttpUtils().launchSourceCode();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.code),
                    SizedBox(width: 16),
                    Text(StringUtils.kSourceCode),
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
                    Text(StringUtils.kDonate),
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
                    Text(StringUtils.kAbout),
                  ],
                ),
              )
                  .animate()
                  .fade(delay: 1500.ms, duration: 1000.ms)
                  .move(delay: 1500.ms, duration: 1000.ms),
              const Divider(),
            ],
          ),
        ),
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
                  StringUtils.kAbout,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                const Text(
                  StringUtils.kPackages,
                  textAlign: TextAlign.center,
                ),
                const Divider(),
                ElevatedButton(
                  onPressed: () async {
                    await HttpUtils().launchFlutterRiverpod();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.database),
                      SizedBox(width: 16),
                      Text(StringUtils.kRiverpod),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    await HttpUtils().launchFlexColorScheme();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.paintRoller),
                      SizedBox(width: 16),
                      Text(StringUtils.kFlexColorScheme),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    await HttpUtils().launchFlutterAnimate();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.arrowsUpDownLeftRight),
                      SizedBox(width: 16),
                      Text(StringUtils.kFlutterAnimate),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    await HttpUtils().launchJustAudio();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.music),
                      SizedBox(width: 16),
                      Text(StringUtils.kJustAudio),
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
                    StringUtils.kDonations,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  const Text(
                    StringUtils.kDonationsPlease,
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
                        Text(StringUtils.kOneTimeDonation),
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
                        Text(StringUtils.kMonthlySubscription),
                      ],
                    ),
                  ),
                  const Divider(),
                  const Text(
                    StringUtils.kDonateViaPhone,
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
                          Image.asset(
                            StringUtils.kOneTimeQR,
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
                            StringUtils.kMonthlyQR,
                            height: MediaQuery.sizeOf(context).height * 0.2,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    child: const Text(StringUtils.kNotNow),
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
