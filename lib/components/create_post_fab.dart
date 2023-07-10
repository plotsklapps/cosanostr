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
  State<CreatePostFAB> createState() => _CreatePostFABState();
}

class _CreatePostFABState extends State<CreatePostFAB> {
  final _noteController = TextEditingController();
  final GlobalKey<FormFieldState> _formKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurpleAccent,
      tooltip: 'Create a new post',
      elevation: 2,
      highlightElevation: 4,
      foregroundColor: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.deepPurpleAccent, Colors.indigoAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          const Icon(FontAwesomeIcons.featherPointed),
        ],
      ),
      onPressed: () async {
        _noteController.clear();
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: ((context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.indigo,
                      ),
                      child: const Center(
                        child: Text(
                          'Create a Noost',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: NoostTextFormField(
                        maxLines: 5,
                        hintText: 'Type your Noost here...',
                        controller: _noteController,
                        formKey: _formKey,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your note.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    widget.isNotePublishing
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              NoostTextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                label: 'Cancel',
                              ),
                              const SizedBox(width: 16),
                              NoostOkButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    widget.publishNote(
                                        _noteController.text.trim());
                                  } else {
                                    _formKey.currentState?.setState(() {});
                                  }
                                },
                                label: 'Noost!',
                              ),
                              const SizedBox(width: 24),
                            ],
                          )
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
