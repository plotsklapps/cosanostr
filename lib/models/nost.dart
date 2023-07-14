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
