


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/user_model.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/root_screen.dart';
import 'package:ecommerce_app/services/my_app_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  Future<void> _googleSignIn({required BuildContext context}) async {
    try {
      UserCredential authResults;

      // =======================
      //  WEB SIGN-IN (CORRECT)
      // =======================
      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        authResults =
            await FirebaseAuth.instance.signInWithPopup(googleProvider);
      }
      // =========================
      //  MOBILE SIGN-IN (ANDROID)
      // =========================
      else {
        final googleSignIn = GoogleSignIn();
        final googleAccount = await googleSignIn.signIn();

        if (googleAccount == null) return;

        final googleAuth = await googleAccount.authentication;

        if (googleAuth.idToken == null) {
          throw FirebaseAuthException(
            code: 'ERROR_NO_ID_TOKEN',
            message: 'Missing Google ID Token',
          );
        }

        authResults = await FirebaseAuth.instance.signInWithCredential(
          GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ),
        );
      }

      // =======================
      // CREATE USER IF NEW
      // =======================
      final isNewUser =
          authResults.additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        final user = authResults.user!;
        final newUser = UserModel(
          uid: user.uid,
          username: user.displayName ?? '',
          email: user.email ?? '',
          userImage: user.photoURL ?? '',
          createdAt: Timestamp.now(),
          userWish: [],
          userCart: [],
          role: 'user',
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(newUser.toMap());
      }

      // =======================
      //  REFRESH PROVIDER
      // =======================
      final userProvider =
          Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchUser();

      // =======================
      //  NAVIGATE
      // =======================
      if (context.mounted) {
        Navigator.pushReplacementNamed(
          context,
          RootScreen.routName,
        );
      }
    } on FirebaseException catch (error) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: error.message ?? error.code,
        fct: () {},
      );
    } catch (error) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: error.toString(),
        fct: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: const EdgeInsets.all(6.0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      icon: const Icon(Ionicons.logo_google, color: Colors.red),
      label: const Text(
        "Sign in with Google",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () async {
        await _googleSignIn(context: context);
      },
    );
  }
}