import 'package:cosanostr/all_imports.dart';

class JoinCosaNostrFAB extends ConsumerWidget {
  const JoinCosaNostrFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
