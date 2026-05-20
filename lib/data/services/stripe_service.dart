import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  final String backendUrl = "http://10.20.0.111:8081/api/payments"; // IP de votre PC

  Future<void> makePayment(double amount, String currency) async {
    try {
      // 1. Create Payment Intent on the backend
      final response = await http.post(
        Uri.parse('$backendUrl/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': (amount * 100).toInt(), // Stripe expects cents
          'currency': currency,
        }),
      );

      if (response.statusCode != 200) {
        print("Erreur Backend Stripe: ${response.body}");
        throw Exception("Erreur Serveur: ${response.body}");
      }

      final paymentData = json.decode(response.body);
      final clientSecret = paymentData['paymentIntent'];

      // 2. Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'E-commerce App',
        ),
      );

      // 3. Display Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      print("Payment successful!");
    } catch (e) {
      print("Error during payment: $e");
      rethrow;
    }
  }
}
