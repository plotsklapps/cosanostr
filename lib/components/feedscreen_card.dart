import 'package:cosanostr/all_imports.dart';

class FeedScreenCard extends StatelessWidget {
  const FeedScreenCard({
    super.key,
    required this.nost,
  });

  final Nost nost;

  List<String>? extractImage(String text) {
    final RegExp exp = RegExp(
      r'(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png|jpeg)',
      caseSensitive: false,
      multiLine: true,
    );

    final Iterable<Match> matches = exp.allMatches(text);

    final List<String> imageLinks = matches.map((Match match) {
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
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: FadeInImage(
                placeholder: const AssetImage('assets/images/spinner.png'),
                image: NetworkImage(nost.avatarUrl),
              ).image,
            ),
            title: Text(nost.name),
            subtitle: Text('@${nost.username.toLowerCase()} • ${nost.time}'),
            trailing: const Icon(Icons.more_vert),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(nost.content),
          ),
          if (imageLinks != null && imageLinks.isNotEmpty)
            Card(
              child: Center(
                child: Stack(
                  children: <Widget>[
                    const Placeholder(
                      fallbackHeight: 200,
                      color: Colors.transparent,
                    ),
                    Center(
                      child: FadeInImage(
                        placeholder: const AssetImage(
                          'assets/images/loading_fireworks.gif',
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
