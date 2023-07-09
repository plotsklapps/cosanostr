import 'package:cosanostr/all_imports.dart';

class CosaNostrCard extends StatelessWidget {
  const CosaNostrCard({
    super.key,
    required this.nost,
  });

  final Nost nost;

  List<String>? extractImage(String text) {
    final RegExp exp = RegExp(
      r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png|jpeg)",
      caseSensitive: false,
      multiLine: true,
    );

    final Iterable<Match> matches = exp.allMatches(text);

    final List<String> imageLinks = matches.map((match) {
      return match.group(0)!;
    }).toList();

    return imageLinks.isNotEmpty ? imageLinks : null;
  }

  @override
  Widget build(BuildContext context) {
    final List<String>? imageLinks = extractImage(nost.content);
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: FadeInImage(
                placeholder:
                    const NetworkImage('https://i.ibb.co/mJkxDkb/satoshi.png'),
                image: NetworkImage(nost.avatarUrl),
              ).image,
            ),
            title: Text(nost.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text('@${nost.username.toLowerCase()} • ${nost.time}',
                style: TextStyle(color: Colors.grey.shade400)),
            trailing: const Icon(Icons.more_vert, color: Colors.grey),
          ),
          Divider(height: 1, color: Colors.grey.shade400),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child:
                Text(nost.content, style: const TextStyle(color: Colors.white)),
          ),
          if (imageLinks != null && imageLinks.isNotEmpty)
            Card(
              child: Center(
                child: Stack(
                  children: [
                    const Placeholder(
                      fallbackHeight: 200,
                      color: Colors.transparent,
                    ),
                    Center(
                      child: FadeInImage(
                        placeholder: const NetworkImage(
                          'https://i.ibb.co/D9jqXgR/58038897-167f0280-7ae6-11e9-94eb-88e880a25f0f.gif',
                        ),
                        image: NetworkImage(imageLinks.first),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
