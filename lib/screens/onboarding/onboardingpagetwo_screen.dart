import 'package:cosanostr/all_imports.dart';

final StateProvider<String> userNameProvider =
    StateProvider<String>((StateProviderRef<String> ref) {
  return '';
});

final StateProvider<bool> isSubmitPressed =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
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
                    'Are you familiar with Nostr?',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (BuildContext context) {
                            return const ResponsiveLayout();
                          },
                        ),
                      );
                    },
                    child: const Text('JUMP RIGHT IN'),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Otherwise, tell us your name:',
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
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      ref.read(isSubmitPressed.notifier).state = true;
                      userNameTextEditingController.clear();
                    },
                    child: const Text('SUBMIT'),
                  ),
                  const SizedBox(height: 16.0),
                  if (ref.watch(isSubmitPressed))
                    Column(
                      children: <Widget>[
                        const Text(
                          'Good. From now on, you will be knows as:',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          ref.watch(userNameProvider),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
