class Noost {
  final String noteId;
  final String avatarUrl;
  final String name;
  final String username;
  final String time;
  final String content;
  final String pubkey;
  final String? imageUrl;

  Noost({
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
