import 'package:cosanostr/all_imports.dart';

class NoostCard extends StatelessWidget {
  const NoostCard({
    super.key,
    required this.noost,
  });

  final Noost noost;

  List<String>? extractImage(String text) {
    final RegExp exp = RegExp(
      r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png|jpeg)",
      caseSensitive: false,
      multiLine: true,
    );

    final Iterable<Match> matches = exp.allMatches(text);

    final List<String> imageLinks =
        matches.map((match) => match.group(0)!).toList();

    return imageLinks.isNotEmpty ? imageLinks : null;
  }

  @override
  Widget build(BuildContext context) {
    final List<String>? imageLinks = extractImage(noost.content);
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: FadeInImage(
                placeholder:
                    const NetworkImage('https://i.ibb.co/mJkxDkb/satoshi.png'),
                image: NetworkImage(noost.avatarUrl),
              ).image,
            ),
            title:
                Text(noost.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text('@${noost.username.toLowerCase()} • ${noost.time}',
                style: TextStyle(color: Colors.grey.shade400)),
            trailing: const Icon(Icons.more_vert, color: Colors.grey),
          ),
          Divider(height: 1, color: Colors.grey.shade400),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(noost.content,
                style: const TextStyle(color: Colors.white)),
          ),
          if (imageLinks != null && imageLinks.isNotEmpty)
            Center(
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
        ],
      ),
    );
  }
}
