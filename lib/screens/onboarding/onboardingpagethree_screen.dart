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
If you want, you can set up your preferences here. If you already like what you see, just click next, ${ref.watch(userNameProvider)}.''',
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () async {
                          await showModalBottomSheet<void>(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return const SettingsModal();
                            },
                          );
                        },
                        child: const Text('PREFERENCES').animate(
                          onPlay: (AnimationController controller) {
                            controller.repeat();
                          },
                        ).shake(
                          delay: 5000.ms,
                          duration: 2000.ms,
                        ),
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
