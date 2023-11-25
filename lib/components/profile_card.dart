import 'dart:io';

import 'package:cosanostr/all_imports.dart';

class CardPicture extends StatelessWidget {
  const CardPicture({super.key, required this.onTap, this.imagePath});

  final VoidCallback onTap;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (imagePath != null) {
      return Card(
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(10.0),
          width: size.width * .70,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: FileImage(
                File(imagePath!),
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(3.0, 3.0),
                      blurRadius: 2.0,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
          width: size.width * .70,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Attach Picture',
                style: TextStyle(fontSize: 17.0, color: Colors.grey[600]),
              ),
              Icon(
                Icons.photo_camera,
                color: Colors.indigo[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
