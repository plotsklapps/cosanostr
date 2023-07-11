import 'package:cosanostr/all_imports.dart';

class FeedScreenFAB extends StatefulWidget {
  const FeedScreenFAB({
    super.key,
    required this.publishNote,
    required this.isNotePublishing,
  });

  final void Function(String?) publishNote;
  final bool isNotePublishing;

  @override
  State<FeedScreenFAB> createState() {
    return FeedScreenFABState();
  }
}

class FeedScreenFABState extends State<FeedScreenFAB> {
  final TextEditingController noteController = TextEditingController();
  final GlobalKey<FormFieldState<dynamic>> formKey =
      GlobalKey<FormFieldState<dynamic>>();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      tooltip: 'Create a new Nost',
      label: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('NEW'),
          SizedBox(width: 8.0),
          Icon(FontAwesomeIcons.featherPointed),
        ],
      ),
      onPressed: () async {
        noteController.clear();
        await showDialog<void>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              icon: const Icon(FontAwesomeIcons.featherPointed),
              title: const Text('Create a Nost'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: noteController,
                    key: formKey,
                    maxLines: 5,
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
                    )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
