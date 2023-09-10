import 'package:cosanostr/all_imports.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final String npub =
        ref.watch(nip19Provider).npubEncode(ref.watch(publicKeyProvider));

    // Hardcoded the Metadata for now, but still only returning the instance
    // of Metadata, not the info itself...
    final String profileInfo = Metadata(
      banner: 'https://i.imgur.com/2M2p9JL.png',
      lud06: '2021-07-01T00:00:00.000Z',
      lud16: '2021-07-01T00:00:00.000Z',
      website: 'https://cosanostr.art',
      picture: 'https://i.imgur.com/2M2p9JL.png',
      display_name: 'Cosa Nostr',
      name: 'Cosa Nostr',
      about: 'Cosa Nostr is a decentralized social network.',
      username: 'cosanostr',
      displayName: 'Cosa Nostr',
      nip05: 'cosanostr',
      followingCount: 0,
      followersCount: 0,
      nip05valid: true,
      zapService: 'cosanostr',
    ).toString();

    Logger().i(profileInfo);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'PROFILEBANNER',
                          style: TextStyle(fontSize: 36.0),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle,
                          size: 64.0,
                        ),
                        SizedBox(width: 16.0),
                        Text('USERNAME'),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Text('WEBSITE'),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Text('ABOUT'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('NPUB: $npub ... more info will be added here!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
