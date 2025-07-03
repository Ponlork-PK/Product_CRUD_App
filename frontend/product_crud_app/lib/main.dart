import 'package:flutter/material.dart';
import 'package:product_crud_app/Provider/add_product_provider.dart';
import 'package:product_crud_app/Provider/delete_product_provider.dart';
import 'package:product_crud_app/Provider/edit_product_provider.dart';
import 'package:product_crud_app/Provider/get_product_provider.dart';
import 'package:provider/provider.dart';
import 'myapp.dart'; // your custom app file that loads HomeScreen

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GetProductProvider()),
        ChangeNotifierProvider(create: (_) => AddProductProvider()),
        ChangeNotifierProvider(create: (_) => EditProductProvider()),
        ChangeNotifierProvider(create: (_) => DeleteProductProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
