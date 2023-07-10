import 'package:cosanostr/all_imports.dart';

// To achieve some form of responsiveness, I figured the app would look nice
// appearing as a phone on larger screens. I've created a PhoneContainer widget
// that will be used to wrap the app's content. It's a simple container with
// rounded corners and a border. The child widget will be clipped to the
// container's rounded corners.
class PhoneContainer extends StatelessWidget {
  final Widget child;

  const PhoneContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final double maxWidth = MediaQuery.sizeOf(context).width;
    final double maxHeight = MediaQuery.sizeOf(context).height;
    return Center(
      child: Container(
        // Set the container's width and height to be 50% and 90% of the screen
        // size respectively. This will give it a nice phone-like appearance.
        width: maxWidth * 0.5,
        height: maxHeight * 0.9,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32.0),
            topRight: Radius.circular(32.0),
            bottomLeft: Radius.circular(32.0),
            bottomRight: Radius.circular(32.0),
          ),
          border: Border.all(color: Colors.black, width: 8.0),
          boxShadow: <BoxShadow>[
            // Add a shadow around the container for a more realistic look.
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        // Clip the child widget to the container's curved corners.
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          child: child,
        ),
      ),
    );
  }
}
