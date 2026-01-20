import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class OrdersScreen extends StatelessWidget {
  static const routName = "/OrdersScreen";

  const OrdersScreen({super.key});

  Icon _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return const Icon(IconlyLight.time_circle);
      case 'processing':
        return const Icon(IconlyLight.setting);
      case 'shipped':
        return const Icon(IconlyLight.send);
      case 'delivered':
        return const Icon(IconlyLight.tick_square);
      default:
        return const Icon(Icons.help);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(body: Center(child: Text('Please log in')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').where('userId', isEqualTo: userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final orders = snapshot.data!.docs.map((doc) {
            return OrderModel.fromDocument(doc.id, doc.data() as Map<String, dynamic>);
          }).toList();

          if (orders.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Order ID: ${order.orderId}'),
                  subtitle: Text('Total: \$${order.totalPrice} | Date: ${order.orderDate.toDate().toString().split(' ')[0]}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _getStatusIcon(order.orderStatus),
                      const SizedBox(width: 4),
                      Text(order.orderStatus),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}