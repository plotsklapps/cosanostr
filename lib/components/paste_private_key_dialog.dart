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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Enter your private key',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            NoostTextFormField(
                hintText: 'Enter nsec or hex',
                controller: keyController,
                formKey: formKey,
                validator: keyValidator),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NoostTextButton(
                  onPressed: onCancelPressed,
                  label: 'Cancel',
                  color: Colors.grey,
                ),
                NoostOkButton(
                  onPressed: onOKPressed,
                  label: 'OK',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
