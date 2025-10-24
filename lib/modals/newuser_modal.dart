import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:cosanostr/feedscreen_logic.dart';
import 'package:cosanostr/modals/generatenewkeysinfo_modal.dart';
import 'package:cosanostr/modals/privatekey_modal.dart';
import 'package:cosanostr/modals/useprivatekeyinfo_modal.dart';
import 'package:cosanostr/responsive_layout.dart';
import 'package:cosanostr/signals/feedscreen_signals.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals/signals_flutter.dart';

class NewUserModal extends StatefulWidget {
  const NewUserModal({super.key});

  @override
  State<NewUserModal> createState() {
    return NewUserModalState();
  }
}

class NewUserModalState extends State<NewUserModal> {
  final ConfettiController confettiController = ConfettiController();

  @override
  Widget build(BuildContext context) {
    final FeedScreenLogic feedScreenLogic = FeedScreenLogic();
    final bool keysExist = sKeysExist.watch(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          scrollbars: false,
          dragDevices: <PointerDeviceKind>{
            PointerDeviceKind.mouse,
            PointerDeviceKind.stylus,
            PointerDeviceKind.touch,
            PointerDeviceKind.trackpad,
          },
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ConfettiWidget(
                confettiController: confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 50,
                maxBlastForce: 50,
              ),
              const Icon(
                FontAwesomeIcons.featherPointed,
                size: 36.0,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Welcome to CosaNostr!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              const Text(
                '''
The anonymous, open-source, free, lightweight and cross-platform Nostr client.''',
                textAlign: TextAlign.center,
              ),
              const Divider(),
              const Text(
                'Please choose your poison:',
                textAlign: TextAlign.end,
              ),
              const SizedBox(height: 16.0),
              ListTile(
                leading: InkWell(
                  onTap: () async {
                    await showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return const GenerateNewKeysInfoModal();
                      },
                    );
                  },
                  child: const Icon(FontAwesomeIcons.circleInfo),
                ),
                title: const Text('GENERATE NEW KEYS'),
                subtitle: const Text('Start fresh with a new identity'),
                trailing: InkWell(
                  onTap: () async {
                    await feedScreenLogic.generateNewKeys().then((_) {
                      if (keysExist) {
                        confettiController.play();
                        Future<void>.delayed(const Duration(seconds: 2),
                            () async {
                          if (context.mounted) {
                            Navigator.pop(context);
                            await Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                                  return const ResponsiveLayout();
                                },
                              ),
                            );
                            if (context.mounted) {
                              snackJoiningSuccesful(context);
                            }
                          }
                        });
                      } else {
                        if (context.mounted) {
                          Navigator.pop(context);
                          snackJoiningFailed(context);
                        }
                      }
                    });
                  },
                  child: const Icon(FontAwesomeIcons.chevronRight),
                ),
              ),
              ListTile(
                leading: InkWell(
                  onTap: () async {
                    await showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return const UsePrivateKeyInfoModal();
                      },
                    );
                  },
                  child: const Icon(FontAwesomeIcons.circleInfo),
                ),
                title: const Text('USE YOUR PRIVATE KEY'),
                subtitle: const Text('Use an existing NSEC or HEX'),
                trailing: InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    await showModalBottomSheet<void>(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: const PrivateKeyModal(),
                        );
                      },
                    );
                  },
                  child: const Icon(FontAwesomeIcons.chevronRight),
                ),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackJoiningFailed(
    BuildContext context,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Oops, something is wrong!',
            ),
            Icon(FontAwesomeIcons.circleExclamation),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      snackJoiningSuccesful(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'You are now a proud member of CosaNostr!',
            ),
            Icon(FontAwesomeIcons.handshake),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
