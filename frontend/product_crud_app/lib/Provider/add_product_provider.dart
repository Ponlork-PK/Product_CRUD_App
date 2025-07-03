import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductProvider extends ChangeNotifier {
  bool _status = false;
  String _response = '';

  bool get getStatus => _status;
  String get getResponse => _response;

  Future<void> addProduct({
    required String productName,
    required double price,
    required int stock,
  }) async {
    _status = true;
    notifyListeners();

    final url = "http://192.168.1.7:5000/addproduct";

    final body = {
      "PRODUCTNAME": productName,
      "PRICE": price,
      "STOCK": stock,
    };

    try {
      final result = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (result.statusCode == 200 || result.statusCode == 201) {
        final res = json.decode(result.body);
        _response = res["message"] ?? "Product added Successfully!!!";
      } else {
        _response = "Failed: ${result.statusCode}";
      }
    } catch (e) {
      _response = "Error: $e";
    }

    _status = false;
    notifyListeners();
  }

  void clear() {
    _response = '';
    notifyListeners();
  }
}