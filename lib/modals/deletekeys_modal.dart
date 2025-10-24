import 'package:cosanostr/feedscreen_logic.dart';
import 'package:cosanostr/signals/feedscreen_signals.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class DeleteKeysModal extends StatelessWidget {
  const DeleteKeysModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final FeedScreenLogic feedScreenLogic = FeedScreenLogic();
    final bool keysExist = sKeysExist.watch(context);

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
              TextButton(
                onPressed: () async {
                  await feedScreenLogic.deleteKeysFromStorage().then((_) {
                    if (!keysExist) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Keys successfully deleted!',
                            ),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              },
                            ),
                          ),
                        );
                      }
                    }
                  });
                },
                child: const Text(
                  'DELETE',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
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
