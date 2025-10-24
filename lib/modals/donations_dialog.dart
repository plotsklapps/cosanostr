import 'dart:ui';

import 'package:cosanostr/utils/http_utils.dart';
import 'package:cosanostr/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DonationsModal extends StatelessWidget {
  const DonationsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          scrollbars: false,
          dragDevices: <PointerDeviceKind>{
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
          },
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                StringUtils.kDonations,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              const Text(
                StringUtils.kDonationsPlease,
                textAlign: TextAlign.center,
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () async {
                  await HttpUtils().launchOneTimeDonationStripe();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.stripe),
                    SizedBox(width: 16),
                    Text(StringUtils.kOneTimeDonation),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  await HttpUtils().launchMonthlySubscriptionStripe();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.stripe),
                    SizedBox(width: 16),
                    Text(StringUtils.kMonthlySubscription),
                  ],
                ),
              ),
              const Divider(),
              const Text(
                StringUtils.kDonateViaPhone,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('One-time'),
                      Image.asset(
                        StringUtils.kOneTimeQR,
                        height: MediaQuery.sizeOf(context).height * 0.2,
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Monthly'),
                      Image.asset(
                        StringUtils.kMonthlyQR,
                        height: MediaQuery.sizeOf(context).height * 0.2,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                child: const Text(StringUtils.kNotNow),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
