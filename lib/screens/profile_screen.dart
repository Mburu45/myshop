import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/user_model.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routName = "/ProfileScreen";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.getUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              userProvider.clearUser();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user.userImage.isNotEmpty ? NetworkImage(user.userImage) : null,
              child: user.userImage.isEmpty ? const Icon(IconlyLight.profile, size: 50) : null,
            ),
            const SizedBox(height: 16),
            Text('Name: ${user.username}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Email: ${user.email}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Role: ${user.role}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Registered: ${user.createdAt.toDate().toString().split(' ')[0]}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showEditDialog(context, user),
              icon: const Icon(IconlyLight.edit),
              label: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, UserModel user) {
    final nameController = TextEditingController(text: user.username);
    final emailController = TextEditingController(text: user.email);
    final imageController = TextEditingController(text: user.userImage);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final updatedUser = UserModel(
                  uid: user.uid,
                  username: nameController.text,
                  email: emailController.text,
                  userImage: imageController.text,
                  createdAt: user.createdAt,
                  userCart: user.userCart,
                  userWish: user.userWish,
                  role: user.role,
                );
                await FirebaseFirestore.instance.collection('users').doc(user.uid).update(updatedUser.toMap());
                Provider.of<UserProvider>(context, listen: false).setUser(updatedUser);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
