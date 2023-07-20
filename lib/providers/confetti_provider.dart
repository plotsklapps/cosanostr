import 'package:cosanostr/all_imports.dart';

final StateProvider<ConfettiController> confettiControllerProvider =
    StateProvider<ConfettiController>(
        (StateProviderRef<ConfettiController> ref) {
  return ConfettiController(
    duration: const Duration(seconds: 2),
  );
});
