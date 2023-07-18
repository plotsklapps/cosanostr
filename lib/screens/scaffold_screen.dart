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
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: scaffoldKey,
      // The ScaffoldAppBar and ScaffoldDrawer are custom widgets.
      // appBar: const ScaffoldAppBar(),
      endDrawer: ScaffoldDrawer(context, ref),
      body: Builder(
        builder: (BuildContext context) {
          return PageView(
            controller: pageController,
            onPageChanged: (int index) {
              ref.read(currentPageIndexProvider.notifier).state = index;
            },
            children: const <Widget>[
              FeedScreen(),
              ProfileScreen(),
            ],
          );
        },
      ),
      // The BottomNavigationBar is a custom widget.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.earthEurope),
            label: 'Global',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.idCardClip),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.barsStaggered),
            label: 'More',
          ),
        ],
        currentIndex: ref.watch(currentPageIndexProvider),
        onTap: (int index) async {
          ref.read(currentPageIndexProvider.notifier).state = index;
          if (index == 0) {
            await pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.bounceOut,
            );
          } else if (index == 1) {
            await pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.bounceOut,
            );
          } else if (index == 2) {
            // Open the ScaffoldDrawer here!
            scaffoldKey.currentState!.openEndDrawer();
          } else {
            return;
          }
        },
      ),
    );
  }
}
