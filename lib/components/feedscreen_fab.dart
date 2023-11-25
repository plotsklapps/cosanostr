import 'package:cosanostr/all_imports.dart';

class FeedScreenFAB extends ConsumerStatefulWidget {
  const FeedScreenFAB({
    super.key,
    required this.publishNote,
    required this.isNotePublishing,
    required this.ref,
  });

  final WidgetRef ref;
  final void Function(String?) publishNote;
  final bool isNotePublishing;

  @override
  ConsumerState<FeedScreenFAB> createState() {
    return FeedScreenFABState();
  }
}

class FeedScreenFABState extends ConsumerState<FeedScreenFAB> {
  final TextEditingController noteController = TextEditingController();
  final GlobalKey<FormFieldState<dynamic>> formKey =
      GlobalKey<FormFieldState<dynamic>>();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Create a new Nost',
      child: const Icon(FontAwesomeIcons.featherPointed),
      onPressed: () async {
        noteController.clear();
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const Icon(FontAwesomeIcons.featherPointed),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Create a new Nost',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: noteController,
                      key: formKey,
                      maxLines: 15,
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nost appears to be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    if (widget.isNotePublishing)
                      const Center(child: CircularProgressIndicator())
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                widget.publishNote(noteController.text.trim());
                              } else {
                                formKey.currentState?.setState(() {});
                              }
                            },
                            child: const Text('NOST!'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
