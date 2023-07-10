import 'package:cosanostr/all_imports.dart';

class ScaffoldAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ScaffoldAppBar({super.key});

  @override
  Size get preferredSize {
    return const Size.fromHeight(60);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('CosaNostr'),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(
            ref.watch(isConnectedProvider)
                ? FontAwesomeIcons.solidCircleCheck
                : FontAwesomeIcons.circleMinus,
            color: FlexColor.deepPurpleDarkPrimary,
          ),
        ),
      ],
    );
  }
}
