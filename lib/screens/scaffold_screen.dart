import 'package:cosanostr/all_imports.dart';

// The ScaffoldScreen is the main screen of the app. It contains the
// AppBar, the Drawer, the PageView and the BottomNavigationBar which
// is visible throughout the entire application. The PageView is used
// to navigate between the different screens of the app. For now, only
// the FeedScreen is implemented.

class ScaffoldScreen extends ConsumerStatefulWidget {
  const ScaffoldScreen({super.key});

  @override
  ConsumerState<ScaffoldScreen> createState() {
    return _ScaffoldScreenState();
  }
}

class _ScaffoldScreenState extends ConsumerState<ScaffoldScreen> {
  // Instantiate a PageController to have access to animations during
  // navigation as well.
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    // Starting index = always 0.
    pageController =
        PageController(initialPage: ref.read(currentPageIndexProvider));
  }

  @override
  void dispose() {
    // Kill the PageController.
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The ScaffoldAppBar and ScaffoldDrawer are custom widgets.
      appBar: const ScaffoldAppBar(),
      drawer: ScaffoldDrawer(ref: ref),
      body: PageView(
        controller: pageController,
        onPageChanged: (int index) {
          ref.read(currentPageIndexProvider.notifier).state = index;
        },
        children: const <Widget>[
          FeedScreen(),
          Placeholder(),
          Placeholder(),
        ],
      ),
      // The BottomNavigationBar is a custom widget.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ref.watch(currentPageIndexProvider),
        onTap: (int index) async {
          ref.read(currentPageIndexProvider.notifier).state = index;
          // When the user taps on a BottomNavigationBarItem, the
          // PageController is used to animate to the corresponding
          // page.
          await pageController.animateToPage(
            ref.watch(currentPageIndexProvider),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.bounceOut,
          );
          // The currentPageIndexProvider is updated to reflect the
          // current page.
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.searchengin),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}
