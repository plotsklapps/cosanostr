import 'package:cosanostr/all_imports.dart';

class FeedScreenDesktop extends StatefulWidget {
  const FeedScreenDesktop({super.key});

  @override
  State<FeedScreenDesktop> createState() {
    return FeedScreenDesktopState();
  }
}

class FeedScreenDesktopState extends State<FeedScreenDesktop> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: PhoneContainer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ProfileScreen(),
              ),
              Expanded(
                flex: 2,
                child: FeedScreen(),
              ),
              Expanded(
                child: MoreScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
