import 'package:cosanostr/all_imports.dart';

class PastePrivateKeyDialog extends StatelessWidget {
  const PastePrivateKeyDialog({
    super.key,
    required this.keyController,
    required this.formKey,
    required this.keyValidator,
    required this.onCancelPressed,
    required this.onOKPressed,
  });

  final TextEditingController keyController;
  final Key formKey;
  final String? Function(String?)? keyValidator;
  final void Function()? onCancelPressed;
  final void Function()? onOKPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(FontAwesomeIcons.userLock),
      title: const Text('Enter your private key'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter NSEC or HEX',
            ),
            controller: keyController,
            key: formKey,
            validator: keyValidator,
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
        ElevatedButton(
          onPressed: onOKPressed,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
