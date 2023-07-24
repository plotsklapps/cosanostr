import 'dart:html';

import 'package:cosanostr/all_imports.dart';

final StateProvider<String?> userNameProvider =
    StateProvider<String?>((StateProviderRef<String?> ref) {
  return null;
});

class OnboardingPageTwo extends ConsumerStatefulWidget {
  const OnboardingPageTwo({
    super.key,
  });

  @override
  ConsumerState<OnboardingPageTwo> createState() {
    return OnboardingPageTwoState();
  }
}

class OnboardingPageTwoState extends ConsumerState<OnboardingPageTwo> {
  late TextEditingController userNameTextEditingController;
  File? image;

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

  Future<void> addPicture() async {
    try {
      final Future<XFile?> userPicture =
          ImagePicker().pickImage(source: ImageSource.gallery);

      final File userPictureTemp = File(userPicture.path);
    } catch (error) {}
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
                      ref.read(userNameProvider.notifier).state = userInput;
                    },
                  ),
                  const SizedBox(height: 80.0),
                  const Text(
                    'Do you have a picture that you would like to use as an avatar?',
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
