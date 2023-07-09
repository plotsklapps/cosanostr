import 'package:flutter/material.dart';

class NoostPopupMenu extends StatelessWidget {
  final Set<String> connectedRelays;
  final Set<String> failedRelays;
  final List<String> relaysList;

  const NoostPopupMenu({
    Key? key,
    required this.connectedRelays,
    required this.failedRelays,
    required this.relaysList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Set<String> missingRelays = Set<String>.from(relaysList)
        .difference(connectedRelays)
        .difference(failedRelays);

    failedRelays.addAll(missingRelays);

    List<PopupMenuEntry<String>> menuItems = [];

    // Add connected relays to menu
    for (String relay in connectedRelays) {
      menuItems.add(
        PopupMenuItem<String>(
          value: relay,
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  relay,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Add failed relays to menu
    for (String relay in failedRelays) {
      menuItems.add(
        PopupMenuItem<String>(
          value: relay,
          child: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  relay,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      offset: const Offset(0, 50),
      itemBuilder: (BuildContext context) => menuItems,
      onSelected: (String value) {
        // Do something when a menu item is selected
      },
    );
  }
}
