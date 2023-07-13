import 'package:cosanostr/all_imports.dart';

class HttpUtils {
  final Uri oneTimeDonationStripe =
      Uri.parse('https://buy.stripe.com/9AQbJy7lEdPQ9XOcMM');
  final Uri monthlySubscriptionStripe =
      Uri.parse('https://buy.stripe.com/aEU28Y8pIcLM3zq3cd');

  Future<void> launchOneTimeDonationStripe() async {
    if (!await launchUrl(oneTimeDonationStripe)) {
      throw Exception('Could not launch $oneTimeDonationStripe');
    }
  }

  Future<void> launchMonthlySubscriptionStripe() async {
    if (!await launchUrl(monthlySubscriptionStripe)) {
      throw Exception('Could not launch $monthlySubscriptionStripe');
    }
  }
}
