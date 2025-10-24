import 'package:cosanostr/signals/feedscreen_signals.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:signals/signals_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // On initState, we call the getProfileData function, which will fetch the
    // profile data from the relay.
    getProfileData(sPublicKey.value);
  }

  Future<void> getProfileData(String npub) async {
    // We fetch the user's profile data from the relay
    final Metadata? profileData = sMetaDataMap.value[npub];
  }

  @override
  Widget build(BuildContext context) {
    final Nip19 nip19 = Nip19();
    final Logger logger = Logger();

    // First, we fetch the npub as String
    final String npub = nip19.npubEncode(sPublicKey.watch(context));

    // Then, we check if the metadataProvider contains the npub, but somehow
    // can't get this to work yet?
    if (sMetaDataMap.value.containsKey(npub)) {
      final Metadata? metadata = sMetaDataMap.value[npub];
      logger.i(metadata);
    } else {
      logger.i('No metadata for $npub');
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
