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
  void initState() {
    super.initState();
    // On initState, we call the getProfileData function, which will fetch the
    // profile data from the relay.
    getProfileData(ref.read(publicKeyProvider));
  }

  Future<void> getProfileData(String npub) async {
    // We fetch the user's profile data from the relay
    final Metadata? profileData = ref.read(metaDataProvider)[npub];
  }

  @override
  Widget build(BuildContext context) {
    // First, we fetch the npub as String
    final String npub =
        ref.watch(nip19Provider).npubEncode(ref.watch(publicKeyProvider));

    // Then, we check if the metadataProvider contains the npub, but somehow
    // can't get this to work yet?
    if (ref.read(metaDataProvider).containsKey(npub)) {
      final Metadata? metadata = ref.read(metaDataProvider)[npub];
      Logger().i(metadata);
    } else {
      Logger().i('No metadata for $npub');
    }

    return SafeArea(
      child: Scaffold(
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
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'PROFILEBANNER',
                            style: TextStyle(fontSize: 36.0),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
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
                        children: <Widget>[
                          Text('WEBSITE'),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: <Widget>[
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
      ),
    );
  }
}
