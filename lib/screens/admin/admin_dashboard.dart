import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/order_model.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/models/user_model.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatefulWidget {
  static const routName = "/AdminDashboard";

  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeOverview(onNavigate: (index) => setState(() => currentIndex = index)),
      const ProductsManagement(),
      const OrdersManagement(),
      const UsersManagement(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(label: "Admin Dashboard"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
            icon: const Icon(IconlyLight.logout),
          ),
        ],
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.bag),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.document),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.profile),
            label: "Users",
          ),
        ],
      ),
    );
  }
}

class HomeOverview extends StatelessWidget {
  final Function(int) onNavigate;

  const HomeOverview({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildSummaryCard(
            icon: IconlyLight.bag,
            title: 'Total Products',
            stream: FirebaseFirestore.instance.collection('products').snapshots(),
            builder: (snapshot) => snapshot.data!.docs.length.toString(),
            onTap: () => onNavigate(1),
          ),
          _buildSummaryCard(
            icon: IconlyLight.buy,
            title: 'Total Orders',
            stream: FirebaseFirestore.instance.collection('orders').snapshots(),
            builder: (snapshot) => snapshot.data!.docs.length.toString(),
            onTap: () => onNavigate(2),
          ),
          _buildSummaryCard(
            icon: IconlyLight.profile,
            title: 'Registered Users',
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (snapshot) => snapshot.data!.docs.length.toString(),
            onTap: () => onNavigate(3),
          ),
          _buildSummaryCard(
            icon: IconlyLight.wallet,
            title: 'Total Revenue',
            stream: FirebaseFirestore.instance.collection('orders').snapshots(),
            builder: (snapshot) {
              double total = 0;
              for (var doc in snapshot.data!.docs) {
                total += double.tryParse(doc['totalPrice'] ?? '0') ?? 0;
              }
              return '\$${total.toStringAsFixed(2)}';
            },
            onTap: () => onNavigate(2),
          ),
          _buildSummaryCard(
            icon: IconlyLight.danger,
            title: 'Low Stock Alerts',
            stream: FirebaseFirestore.instance.collection('products').snapshots(),
            builder: (snapshot) {
              int count = 0;
              for (var doc in snapshot.data!.docs) {
                int qty = doc['productQuantity'] ?? 0;
                if (qty < 5) count++;
              }
              return count.toString();
            },
            onTap: () => onNavigate(1),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required Stream<QuerySnapshot> stream,
    required String Function(AsyncSnapshot<QuerySnapshot>) builder,
    required VoidCallback onTap,
  }) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Card(
            child: Center(child: Text('Error')),
          );
        }
        String value = builder(snapshot);
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 48, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class UsersManagement extends StatelessWidget {
  const UsersManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final users = snapshot.data!.docs.map((doc) {
            return UserModel.fromDocument(doc.id, doc.data() as Map<String, dynamic>);
          }).toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.userImage.isNotEmpty ? NetworkImage(user.userImage) : null,
                    child: user.userImage.isEmpty ? const Icon(IconlyLight.profile) : null,
                  ),
                  title: Text(user.username),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.email),
                      Text('Role: ${user.role} | Registered: ${user.createdAt.toDate().toString().split(' ')[0]}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(IconlyLight.show),
                        onPressed: () {
                          _showUserDetailsDialog(context, user);
                        },
                      ),
                      IconButton(
                        icon: const Icon(IconlyLight.lock),
                        onPressed: () {
                          // Toggle disabled, assume field exists
                          bool isDisabled = user.role == 'disabled'; // placeholder
                          FirebaseFirestore.instance.collection('users').doc(user.uid).update({'role': isDisabled ? 'user' : 'disabled'});
                        },
                      ),
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

  void _showUserDetailsDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(user.username),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${user.email}'),
                Text('Role: ${user.role}'),
                Text('Registered: ${user.createdAt.toDate()}'),
                Text('Cart Items: ${user.userCart.length}'),
                Text('Wishlist Items: ${user.userWish.length}'),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
          ],
        );
      },
    );
  }
}

class ProductsManagement extends StatefulWidget {
  const ProductsManagement({super.key});

  @override
  State<ProductsManagement> createState() => _ProductsManagementState();
}

class _ProductsManagementState extends State<ProductsManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductDialog(context);
        },
        child: const Icon(IconlyLight.plus),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final products = snapshot.data!.docs.map((doc) {
            return ProductModel.fromDocument(doc.id, doc.data() as Map<String, dynamic>);
          }).toList();

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.all(8.0),
                color: product.productQuantity < 5 ? Colors.orange.shade100 : null,
                child: ListTile(
                  leading: Image.network(
                    product.productImage,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 50),
                  ),
                  title: Text(product.productTitle),
                  subtitle: Text('Price: \$${product.productPrice} | Qty: ${product.productQuantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(IconlyLight.edit),
                        onPressed: () {
                          _showEditProductDialog(context, product);
                        },
                      ),
                      IconButton(
                        icon: const Icon(IconlyLight.delete),
                        onPressed: () {
                          _deleteProduct(product.productId);
                        },
                      ),
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

  void _showAddProductDialog(BuildContext context) {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final categoryController = TextEditingController();
    final descriptionController = TextEditingController();
    final imageController = TextEditingController();
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.numberWithOptions(decimal: true)),
                TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
                TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
                TextField(controller: imageController, decoration: const InputDecoration(labelText: 'Image URL')),
                TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                try {
                  final quantity = int.parse(quantityController.text);
                  final product = ProductModel(
                    productId: '',
                    productTitle: titleController.text,
                    productPrice: priceController.text,
                    productCategory: categoryController.text,
                    productDescription: descriptionController.text,
                    productImage: imageController.text,
                    productQuantity: quantity,
                    createdAt: Timestamp.now(),
                  );
                  await FirebaseFirestore.instance.collection('products').add(product.toMap());
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditProductDialog(BuildContext context, ProductModel product) {
    final titleController = TextEditingController(text: product.productTitle);
    final priceController = TextEditingController(text: product.productPrice);
    final categoryController = TextEditingController(text: product.productCategory);
    final descriptionController = TextEditingController(text: product.productDescription);
    final imageController = TextEditingController(text: product.productImage);
    final quantityController = TextEditingController(text: product.productQuantity.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.numberWithOptions(decimal: true)),
                TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
                TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
                TextField(controller: imageController, decoration: const InputDecoration(labelText: 'Image URL')),
                TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                try {
                  final quantity = int.parse(quantityController.text);
                  final updatedProduct = ProductModel(
                    productId: product.productId,
                    productTitle: titleController.text,
                    productPrice: priceController.text,
                    productCategory: categoryController.text,
                    productDescription: descriptionController.text,
                    productImage: imageController.text,
                    productQuantity: quantity,
                    createdAt: product.createdAt,
                  );
                  await FirebaseFirestore.instance.collection('products').doc(product.productId).update(updatedProduct.toMap());
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(String productId) async {
    await FirebaseFirestore.instance.collection('products').doc(productId).delete();
  }
}

class OrdersManagement extends StatelessWidget {
  const OrdersManagement({super.key});

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
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

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Order ID: ${order.orderId}'),
                  subtitle: Text('User: ${order.userName} | Total: \$${order.totalPrice}'),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Status'),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _getStatusIcon(order.orderStatus),
                          const SizedBox(width: 4),
                          DropdownButton<String>(
                            value: order.orderStatus,
                            items: ['pending', 'processing', 'shipped', 'delivered'].map((status) {
                              return DropdownMenuItem(value: status, child: Text(status));
                            }).toList(),
                            onChanged: (newStatus) {
                              if (newStatus != null) {
                                FirebaseFirestore.instance.collection('orders').doc(order.orderId).update({'orderStatus': newStatus});
                              }
                            },
                          ),
                        ],
                      ),
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