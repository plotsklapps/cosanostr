import 'package:cosanostr/all_imports.dart';

Future<void> showConnectedRelaysDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return const ConnectedRelaysDialog();
    },
  );
}

class ConnectedRelaysDialog extends ConsumerWidget {
  const ConnectedRelaysDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      icon: const Icon(FontAwesomeIcons.circleNodes),
      title: const Text('Connected relays'),
      content: Text('${ref.watch(relayPoolProvider).connectedRelays}'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
