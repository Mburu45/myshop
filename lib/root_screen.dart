import 'package:ecommerce_app/screens/home_screen.dart';
import 'package:ecommerce_app/screens/orders_screen.dart';
import 'package:ecommerce_app/screens/products_screen.dart';
import 'package:ecommerce_app/screens/profile_screen.dart';
import 'package:ecommerce_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class RootScreen extends StatefulWidget {
  static const routName = "/RootScreen";

  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  
  int currentScreen = 0;

  late List<Widget> screens;

  late PageController controller;

  @override
  void initState() {
    screens = [
      const HomeScreen(),
      const ProductsScreen(),
      const SearchScreen(),
      const OrdersScreen(),
      const ProfileScreen(),
    ];
    controller = PageController(initialPage: currentScreen);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: screens,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        height: kBottomNavigationBarHeight,
        onDestinationSelected: (index) {
          setState(() {
            currentScreen = index;
          });

          controller.jumpToPage(currentScreen);
        },

        destinations: [
          NavigationDestination(
            selectedIcon: Icon(IconlyBold.home),
            icon: Icon(IconlyLight.home),
            label: "Home",
          ),
          NavigationDestination(
            selectedIcon: Icon(IconlyBold.bag),
            icon: Icon(IconlyLight.bag),
            label: "Products",
          ),
          NavigationDestination(
            selectedIcon: Icon(IconlyBold.search),
            icon: Icon(IconlyLight.search),
            label: "Search",
          ),
          NavigationDestination(
            selectedIcon: Icon(IconlyBold.document),
            icon: Icon(IconlyLight.document),
            label: "Orders",
          ),
          NavigationDestination(
            selectedIcon: Icon(IconlyBold.profile),
            icon: Icon(IconlyLight.profile),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
