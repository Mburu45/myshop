import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset('assets/images/banners/banner1.png'),
            Text(
              "My Shop",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(onPressed: () {}, child: Text("Buy Now")),

            SwitchListTile(
              title: Text(
                themeProvider.getIsDarkTHeme ? "DARK THEME" : "LIGHT THEME",
              ),

              value: themeProvider.getIsDarkTHeme,
              onChanged: (value) {
                themeProvider.setDarkTheme(value);

                print(themeProvider.setDarkTheme(value));
              },
            ),
          ],
        ),
      ),
    );
  }
}
