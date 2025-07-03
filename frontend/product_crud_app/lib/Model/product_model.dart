import 'dart:convert';

List<ProductModel> welcomeFromJson(String str) => List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));

String welcomeToJson(List<ProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
    int productId;
    String productName;
    double price;
    int stock;

    ProductModel({
        required this.productId,
        required this.productName,
        required this.price,
        required this.stock,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productId: json["PRODUCTID"],
        productName: json["PRODUCTNAME"],
        price: json["PRICE"]?.toDouble(),
        stock: json["STOCK"],
    );

    Map<String, dynamic> toJson() => {
        "PRODUCTNAME": productName,
        "PRICE": price,
        "STOCK": stock,
    };
}
