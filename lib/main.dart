import 'package:ecommerce_app/constants/theme_data.dart';
import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/root_screen.dart';
import 'package:ecommerce_app/screens/admin/admin_dashboard.dart';
import 'package:ecommerce_app/screens/auth/login_screen.dart';
import 'package:ecommerce_app/screens/auth/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized;
await  Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform );
 

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return ThemeProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return UserProvider();
          },
        ),
      ],

      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          final userProvider = Provider.of<UserProvider>(context);
          Widget home;
          if (FirebaseAuth.instance.currentUser == null) {
            home = const LoginScreen();
          } else if (userProvider.isAdmin) {
            home = const AdminDashboard();
          } else {
            home = const RootScreen();
          }
          return MaterialApp(
            theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTHeme,
              context: context,
            ),

            home: home,

            routes: {
              LoginScreen.routName: (context) => const LoginScreen(),
              RootScreen.routName: (context) => const RootScreen(),
              AdminDashboard.routName: (context) => const AdminDashboard(),
              RegisterScreen.routName: (context) => const RegisterScreen(),
            },
          );
        },
      ),
    ),
  );
}
