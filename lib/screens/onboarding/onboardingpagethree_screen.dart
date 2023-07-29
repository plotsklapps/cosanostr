import 'dart:ui';

import 'package:cosanostr/all_imports.dart';

class OnboardingPageThree extends ConsumerWidget {
  const OnboardingPageThree({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(
                  scrollbars: false,
                  dragDevices: <PointerDeviceKind>{
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.trackpad,
                    PointerDeviceKind.stylus,
                    PointerDeviceKind.touch,
                  },
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '''
Okay, ${ref.watch(userNameProvider)}. In a few moments you will join CosaNostr with a fresh ''',
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () async {
                          await showModalBottomSheet<void>(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return const ExplainKeypairModal();
                            },
                          );
                        },
                        child: const Text('KEYPAIR').animate(
                          onPlay: (AnimationController controller) {
                            controller.repeat();
                          },
                        ).shake(
                          delay: 5000.ms,
                          duration: 2000.ms,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        '''
CosaNostr is a Nostr client like many others. Your new keypair will work on any''',
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () async {
                          await showModalBottomSheet<void>(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return const ExplainNostrModal();
                            },
                          );
                        },
                        child: const Text('NOSTR').animate(
                          onPlay: (AnimationController controller) {
                            controller.repeat();
                          },
                        ).shake(
                          delay: 5000.ms,
                          duration: 2000.ms,
                        ),
                      ),
                      const Text(
                        '''
client from now on and you will forever keep your identity and data.''',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        '''
That said, if you lose your keys you will forever lose your Nostr identity and data and you will have to generate new keys.''',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/gangster_in_white.png',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
