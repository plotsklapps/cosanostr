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

    final String profileInfo = Metadata(
      banner: 'https://i.imgur.com/2M2p9JL.png',
      lud06: '2021-07-01T00:00:00.000Z',
      lud16: '2021-07-01T00:00:00.000Z',
      website: 'https://cosanostr.art',
      picture: 'https://i.imgur.com/2M2p9JL.png',
      display_name: 'Cosa Nostra',
      name: 'Cosa Nostra',
      about: 'Cosa Nostra is a decentralized social network.',
      username: 'cosanostr',
      displayName: 'Cosa Nostra',
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
                child: Placeholder(),
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
