import 'package:cosanostr/all_imports.dart';

class KeysOptionModalBottomSheet extends StatelessWidget {
  const KeysOptionModalBottomSheet({
    super.key,
    required this.generateNewKeyPressed,
    required this.inputPrivateKeyPressed,
  });

  final void Function()? generateNewKeyPressed;
  final void Function()? inputPrivateKeyPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Choose an option',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          NoostCurveButton(
            onPressed: generateNewKeyPressed,
            label: 'Generate New Key',
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 10),
          NoostCurveButton(
            onPressed: inputPrivateKeyPressed,
            label: 'Input your private key',
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
