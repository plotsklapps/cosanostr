import 'package:cosanostr/all_imports.dart';

class ScaffoldSnackBar extends SnackBar {
  const ScaffoldSnackBar({
    super.key,
    required this.context,
    required super.content,
  });

  final BuildContext context;

  Widget build(BuildContext context) {
    return SnackBar(
      content: content,
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      behavior: SnackBarBehavior.floating,
    );
  }
}
