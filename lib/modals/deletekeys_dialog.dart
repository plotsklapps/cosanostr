import 'package:cosanostr/all_imports.dart';

class DeleteKeysDialog extends ConsumerWidget {
  const DeleteKeysDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Are you sure you want to delete your keys?',
            textAlign: TextAlign.center,
          ),
          const Divider(),
          const Text(
            "This action is irreversible, so make sure you've stored your "
            'nsec somewhere safe.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  await FeedScreenLogic().deleteKeysFromStorage(ref).then((_) {
                    if (!ref.watch(keysExistProvider)) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        ScaffoldSnackBar(
                          context: context,
                          content: const Text('Keys successfully deleted!'),
                        ),
                      );
                    }
                  });
                },
                child: const Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.solidTrashCan,
                      color: Colors.red,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'DELETE',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
