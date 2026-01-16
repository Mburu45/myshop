import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final String userName;
  final List<Map<String, dynamic>> productIds;
  final double totalPrice;
  final String orderStatus;
  final Timestamp orderDate;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.productIds,
    required this.totalPrice,
    required this.orderStatus,
    required this.orderDate,
  });

  factory OrderModel.fromDocument(String id, Map<String, dynamic> doc) {
    return OrderModel(
      orderId: id,
      userId: doc['userId'] ?? '',
      userName: doc['userName'] ?? '',
      productIds: List<Map<String, dynamic>>.from(doc['productIds'] ?? []),
      totalPrice: (doc['totalPrice'] ?? 0.0).toDouble(),
      orderStatus: doc['orderStatus'] ?? 'pending',
      orderDate: doc['orderDate'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'productIds': productIds,
      'totalPrice': totalPrice,
      'orderStatus': orderStatus,
      'orderDate': orderDate,
    };
  }
}