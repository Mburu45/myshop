import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String productId;
  final String productTitle;
  final String productPrice;
  final String productCategory;
  final String productDescription;
  final String productImage;
  final int productQuantity;
  final Timestamp createdAt;

  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productQuantity,
    required this.createdAt,
  });

  factory ProductModel.fromDocument(String id, Map<String, dynamic> doc) {
    return ProductModel(
      productId: id,
      productTitle: doc['productTitle'] ?? '',
      productPrice: doc['productPrice'] ?? '',
      productCategory: doc['productCategory'] ?? '',
      productDescription: doc['productDescription'] ?? '',
      productImage: doc['productImage'] ?? '',
      productQuantity: doc['productQuantity'] ?? 0,
      createdAt: doc['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productTitle': productTitle,
      'productPrice': productPrice,
      'productCategory': productCategory,
      'productDescription': productDescription,
      'productImage': productImage,
      'productQuantity': productQuantity,
      'createdAt': createdAt,
    };
  }
}