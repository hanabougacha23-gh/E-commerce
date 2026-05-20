import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/order_provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: FutureBuilder(
        future: context.read<OrderProvider>().fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Consumer<OrderProvider>(
            builder: (context, orderData, child) {
              if (orderData.orders.isEmpty) {
                return const Center(child: Text('No orders yet.'));
              }
              return ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (context, index) {
                  final order = orderData.orders[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ExpansionTile(
                      title: Text('\$${order.amount.toStringAsFixed(2)}'),
                      subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(order.dateTime)),
                      trailing: _buildStatusBadge(order.status),
                      children: order.products.map((prod) => ListTile(
                        title: Text(prod.product.name),
                        trailing: Text('${prod.quantity}x \$${prod.product.price}'),
                      )).toList(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status == 'Pending' ? Colors.orange[100] : Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: status == 'Pending' ? Colors.orange[900] : Colors.green[900],
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
