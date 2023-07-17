import 'package:cosanostr/all_imports.dart';

Future<void> showDeleteKeysDialog(BuildContext context, WidgetRef ref) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return const DeleteKeysDialog();
    },
  );
}

class DeleteKeysDialog extends ConsumerWidget {
  const DeleteKeysDialog({
    super.key,
  });

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
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('CANCEL'),
        ),
        IconButton(
          onPressed: () async {
            final BuildContext currentContext = context;
            await FeedScreenLogic().deleteKeysFromStorage(ref).then((_) {
              if (!ref.watch(keysExistProvider)) {
                ScaffoldMessenger.of(currentContext).showSnackBar(
                  ScaffoldSnackBar(
                    context: context,
                    content: const Text('Keys successfully deleted!'),
                  ),
                );
              }
            }).then((_) {
              Navigator.pop(context);
            });
          },
          icon: const Icon(
            FontAwesomeIcons.solidTrashCan,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
