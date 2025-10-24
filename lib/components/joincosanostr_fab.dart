import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class JoinCosaNostrFAB extends StatelessWidget {
  const JoinCosaNostrFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      tooltip: 'Create new Keys',
      label: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('JOIN COSANOSTR'),
          SizedBox(width: 8.0),
          Icon(FontAwesomeIcons.circlePlus),
        ],
      ),
      onPressed: () async {
        // await showKeysOptionsDialog(context, ref);
      },
    );
  }
}
