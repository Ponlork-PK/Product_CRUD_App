import 'package:flutter/material.dart';
// import 'package:product_crud_app/Pages/add_product_page.dart';
// import 'package:product_crud_app/Pages/edit_product_page.dart';
import 'package:product_crud_app/Screens/homescreen.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(), // ✅ HomeScreen will now see the provider
    );
  }
}
