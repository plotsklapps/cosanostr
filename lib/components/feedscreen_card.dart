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
    SampleItem? selectedMenu;
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: FadeInImage(
                placeholder: const AssetImage('assets/images/spinner.png'),
                image: NetworkImage(widget.nost.avatarUrl),
              ).image,
            ),
            title: Text(widget.nost.name),
            subtitle: Text(
              '@${widget.nost.username.toLowerCase()} • ${widget.nost.time}',
            ),
            trailing: PopupMenuButton<SampleItem>(
              initialValue: selectedMenu,
              // Callback that sets the selected popup menu item.
              onSelected: (SampleItem item) {
                setState(() {
                  selectedMenu = item;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  ScaffoldSnackBar(
                    context: context,
                    content: const Text(
                      'Work in progress...',
                    ),
                  ),
                );
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<SampleItem>>[
                  const PopupMenuItem<SampleItem>(
                    value: SampleItem.profile,
                    child: Text('Profile'),
                  ),
                  const PopupMenuItem<SampleItem>(
                    value: SampleItem.like,
                    child: Text('Like'),
                  ),
                  const PopupMenuItem<SampleItem>(
                    value: SampleItem.respond,
                    child: Text('Respond'),
                  ),
                ];
              },
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
}
