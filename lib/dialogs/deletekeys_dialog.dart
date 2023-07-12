import 'package:cosanostr/all_imports.dart';

// The Dialog that is only shown to user when keys already
// exist and the trashcan icon is clicked on the FeedScreen().
// Takes two functions, onNoPressed to cancel and onYesPressed
// to delete the keys from this client and go anonymous again.
class DeleteKeysDialog extends ConsumerWidget {
  const DeleteKeysDialog({
    super.key,
    required this.onNoPressed,
    required this.onYesPressed,
  });

  final void Function() onNoPressed;
  final void Function() onYesPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      icon: const Icon(FontAwesomeIcons.circleExclamation),
      title: const Text('DELETE KEYS'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Are you sure you want to delete your keys?',
            textAlign: TextAlign.center,
          ),
          Divider(),
          Text(
            "This action is irreversible, so make sure you've stored your "
            'nsec somewhere safe.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onNoPressed,
          child: const Text('CANCEL'),
        ),
        IconButton(
          onPressed: onYesPressed,
          icon: const Icon(
            FontAwesomeIcons.solidTrashCan,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
