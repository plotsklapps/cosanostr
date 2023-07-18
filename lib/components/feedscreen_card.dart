import 'package:cosanostr/all_imports.dart';

enum SampleItem { profile, like, respond }

class FeedScreenCard extends StatefulWidget {
  const FeedScreenCard({
    super.key,
    required this.nost,
  });

  final Nost nost;

  @override
  State<FeedScreenCard> createState() => _FeedScreenCardState();
}

class _FeedScreenCardState extends State<FeedScreenCard> {
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
    final List<String>? imageLinks = extractImage(widget.nost.content);
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: GestureDetector(
              onTap: () async {
                await showProfileDialog(context);
              },
              child: CircleAvatar(
                backgroundImage: FadeInImage(
                  placeholder: const AssetImage('assets/images/spinner.png'),
                  image: NetworkImage(widget.nost.avatarUrl),
                ).image,
              ),
            ),
            title: Text(widget.nost.name),
            subtitle: Text(
              '@${widget.nost.username.toLowerCase()} • ${widget.nost.time}',
            ),
            trailing: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  ScaffoldSnackBar(
                    context: context,
                    content: const Text(
                      'This feature is coming soon!',
                    ),
                  ),
                );
              },
              icon: const Icon(
                FontAwesomeIcons.heart,
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(widget.nost.content),
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

  Future<void> showProfileDialog(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: FadeInImage(
                  placeholder: const AssetImage('assets/images/spinner.png'),
                  image: NetworkImage(widget.nost.avatarUrl),
                ).image,
                radius: 50.0,
              ),
              const SizedBox(height: 16.0),
              Text(
                widget.nost.name,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Divider(),
              SelectableText('npub: ${widget.nost.pubkey}'),
            ],
          ),
        );
      },
    );
  }
}
