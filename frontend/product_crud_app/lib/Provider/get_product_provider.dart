import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:product_crud_app/Model/product_model.dart';

class GetProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  bool _loading = false;
  String _error = '';

  List<ProductModel> get products => _products;
  bool get loading => _loading;
  String get error => _error;

  Future<void> fetchProducts() async {
    _loading = true;
    notifyListeners();

    const url = "http://192.168.1.7:5000/";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        _products = jsonList.map((json) => ProductModel.fromJson(json)).toList();
        _error = '';
      } else {
        _products = [];
        _error = "Failed to load data: ${response.statusCode}";
      }
    } catch (e) {
      _products = [];
      _error = "Error: $e";
    }

    _loading = false;
    notifyListeners();
  }
}
