import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals/signals.dart';

final Signal<String> sUserName = Signal<String>(
  '',
  debugLabel: 'sUserName',
);

class OnboardingPageTwo extends StatefulWidget {
  const OnboardingPageTwo({
    super.key,
  });

  @override
  State<OnboardingPageTwo> createState() {
    return OnboardingPageTwoState();
  }
}

class OnboardingPageTwoState extends State<OnboardingPageTwo> {
  late TextEditingController userNameTextEditingController;

  @override
  void initState() {
    super.initState();
    userNameTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    userNameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'What should we call you?',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: userNameTextEditingController,
                    textAlign: TextAlign.center,
                    onChanged: (String userInput) {
                      sUserName.value = userInput;
                    },
                  ),
                  const SizedBox(height: 80.0),
                  const Text(
                    '''
Do you have a picture that you would like to use as an avatar?''',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () async {
                      await showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Icon(
                                  FontAwesomeIcons.wrench,
                                  size: 36.0,
                                  color: Colors.orange,
                                ),
                                const SizedBox(height: 16.0),
                                const Text(
                                  'FEATURE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(),
                                const Text(
                                  'Working on this feature, stay tuned!',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16.0),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('BACK'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('ADD PICTURE'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
