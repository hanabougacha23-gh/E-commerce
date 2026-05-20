import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../data/services/stripe_service.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  const PaymentScreen({super.key, required this.totalAmount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    try {
      // 1. Appel du service Stripe pour afficher la Payment Sheet native
      final stripeService = context.read<StripeService>();
      await stripeService.makePayment(widget.totalAmount, 'usd');

      // 2. Si le paiement réussit, on enregistre la commande en base de données
      final cart = context.read<CartProvider>();
      await context.read<OrderProvider>().addOrder(
        cart.items.values.toList(), 
        widget.totalAmount
      );
      
      // 3. Vider le panier
      await cart.clear();
      
      if (mounted) _showStatusDialog(true);
    } catch (e) {
      print("ERREUR CRITIQUE: $e");
      if (mounted) _showStatusDialog(false, message: e.toString());
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showStatusDialog(bool success, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Icon(
          success ? Icons.check_circle : Icons.error, 
          color: success ? Colors.green : Colors.red, 
          size: 80
        ),
        content: Text(
          success 
            ? 'Paiement Réussi !\nVotre commande a été enregistrée.' 
            : 'Échec de l\'enregistrement.\n${message ?? "Veuillez réessayer."}', 
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => success 
                ? Navigator.of(context).popUntil((route) => route.isFirst) 
                : Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: Text(success ? 'Retour à l\'accueil' : 'Réessayer'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paiement Stripe')),
      body: Center(
        child: _isProcessing 
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text("Traitement du paiement sécurisé..."),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.security, size: 100, color: Colors.green),
                  const SizedBox(height: 20),
                  const Text(
                    'Paiement Sécurisé via Stripe',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Montant à payer : \$${widget.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.credit_card),
                          SizedBox(width: 10),
                          Text('Payer Maintenant', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
