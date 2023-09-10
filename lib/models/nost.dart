// A Nost is a post, but it's called a Nost because it's a post on Nost.
// They must have the same format as the Nost API.

class Nost {
  final String noteId;
  final String avatarUrl;
  final String name;
  final String username;
  final String time;
  final String content;
  final String pubkey;
  final String? imageUrl;

  Nost({
    required this.noteId,
    required this.avatarUrl,
    required this.name,
    required this.username,
    required this.time,
    required this.content,
    required this.pubkey,
    this.imageUrl,
  });
}

// I have this class that I want to use on the Profile page, but I don't know
// how to use it. I want to use it to display the profile of the user that
// is logged in.

class Profile {
  final String pubkey;
  final String avatarUrl;
  final String name;
  final String username;

  Profile({
    required this.pubkey,
    required this.avatarUrl,
    required this.name,
    required this.username,
  });
}
