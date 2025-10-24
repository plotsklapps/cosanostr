import 'package:cosanostr/components/phone_container.dart';
import 'package:cosanostr/screens/feed_screen.dart';
import 'package:cosanostr/screens/more_screen.dart';
import 'package:cosanostr/screens/profile_screen.dart';
import 'package:flutter/material.dart';

//Desktopscreen is nothing more than the three mobile
//screens side by side within a border, made in the
//PhoneContainer widget.

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({super.key});

  @override
  State<DesktopScreen> createState() {
    return DesktopScreenState();
  }
}

class DesktopScreenState extends State<DesktopScreen> {
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
