import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteProductProvider extends ChangeNotifier {
  bool _isDeleting = false;
  String _response = '';

  bool get isDeleting => _isDeleting;
  String get response => _response;

  Future<void> deleteProduct(int productId) async {
    _isDeleting = true;
    notifyListeners();

    final String url = "http://192.168.1.7:5000/deleteproduct/$productId";

    try {
      final result = await http.delete(Uri.parse(url));

      if (result.statusCode == 200) {
        _response = "Product deleted successfully!";
      } else {
        _response = "Delete failed: ${result.statusCode}";
      }
    } catch (e) {
      _response = "Error: $e";
    }

    _isDeleting = false;
    notifyListeners();
  }

  void clear() {
    _response = '';
    notifyListeners();
  }
}
