import 'package:cosanostr/all_imports.dart';

class CreatePostFAB extends StatefulWidget {
  const CreatePostFAB({
    Key? key,
    required this.publishNote,
    required this.isNotePublishing,
  }) : super(key: key);

  final Function(String?) publishNote;
  final bool isNotePublishing;

  @override
  State<CreatePostFAB> createState() {
    return CreatePostFABState();
  }
}

class CreatePostFABState extends State<CreatePostFAB> {
  final noteController = TextEditingController();
  final GlobalKey<FormFieldState> formKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      tooltip: 'Create a new Nost',
      label: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('NEW'),
          SizedBox(width: 8.0),
          Icon(FontAwesomeIcons.featherPointed),
        ],
      ),
      onPressed: () async {
        noteController.clear();
        await showDialog(
            barrierDismissible: false,
            context: context,
            builder: ((context) {
              return AlertDialog(
                icon: const Icon(FontAwesomeIcons.featherPointed),
                title: const Text('Create a Nost'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                        controller: noteController,
                        key: formKey,
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your nost';
                          }
                          return null;
                        }),
                    const SizedBox(height: 16.0),
                    widget.isNotePublishing
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                    widget.publishNote(
                                        noteController.text.trim());
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
            }));
      },
    );
  }
}
