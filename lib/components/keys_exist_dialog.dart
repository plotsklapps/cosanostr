import 'package:cosanostr/all_imports.dart';

class KeysExistDialog extends StatefulWidget {
  const KeysExistDialog({
    super.key,
    required this.npubEncoded,
    required this.nsecEncoded,
    required this.hexPriv,
    required this.hexPub,
  });

  final String npubEncoded;
  final String nsecEncoded;
  final String hexPriv;
  final String hexPub;

  @override
  State<KeysExistDialog> createState() => _KeysExistDialogState();
}

class _KeysExistDialogState extends State<KeysExistDialog> {
  bool _toHex = false;

  @override
  Widget build(BuildContext context) {
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
                  'Keys',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Public Key',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    _toHex ? widget.hexPub : widget.npubEncoded,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Private Key',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    _toHex ? widget.hexPriv : widget.nsecEncoded,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Changed to space between to create space for icon buttons
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _toHex = !_toHex;
                          });
                        },
                        icon: const Icon(Icons.autorenew_outlined),
                        color: Colors.grey[700],
                      ),
                      NoostOkButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: 'OK',
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
