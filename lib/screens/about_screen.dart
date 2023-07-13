import 'package:cosanostr/all_imports.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ABOUT'),
          centerTitle: true,
        ),
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
                  await showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return const DonationsDialog();
                    },
                  );
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
                  await showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return const CreditsDialog();
                    },
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.circleInfo),
                    SizedBox(width: 16),
                    Text(StringUtils.kCredits),
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
}
