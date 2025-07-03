import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProductProvider extends ChangeNotifier {
  bool _status = false;
  String _response = '';

  bool get getStatus => _status;
  String get getResponse => _response;

  Future<void> editProduct({
    required int productId,
    required String productName,
    required double price,
    required int stock,
  }) async {
    _status = true;
    notifyListeners();

    final url = "http://192.168.1.7:5000/updateproduct/$productId"; // use your real API endpoint

    final body = {
      "PRODUCTNAME": productName,
      "PRICE": price,
      "STOCK": stock,
    };

    try {
      final result = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (result.statusCode == 200 || result.statusCode == 201) {
        final res = json.decode(result.body);
        _response = res["message"] ?? "Product updated successfully!";
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
