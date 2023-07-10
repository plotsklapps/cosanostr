import 'package:cosanostr/all_imports.dart';

class CosaNostrAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CosaNostrAppBar({
    Key? key,
    required this.title,
    this.keysDialog,
    this.popupMenu,
    required this.isConnected,
    this.deleteKeysDialog,
  }) : super(key: key);

  final String title;
  final Widget? keysDialog;
  final Widget? popupMenu;
  final bool isConnected;
  final Widget? deleteKeysDialog;

  @override
  Size get preferredSize {
    return const Size.fromHeight(60);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(title),
      centerTitle: true,
      actions: [
        popupMenu ?? Container(),
        deleteKeysDialog ?? Container(),
      ],
      leading: keysDialog,
    );
  }
}
