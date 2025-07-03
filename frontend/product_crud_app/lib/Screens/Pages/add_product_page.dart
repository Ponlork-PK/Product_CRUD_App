import 'package:flutter/material.dart';
import 'package:product_crud_app/Provider/add_product_provider.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  @override
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = productNameController.text.trim();
      final price = double.parse(priceController.text.trim());
      final stock = int.parse(stockController.text.trim());

      print("Product: $name | Price: $price | Stock: $stock");

      Provider.of<AddProductProvider>(context, listen: false).addProduct(
        productName: name,
        price: price,
        stock: stock,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Add Product",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: productNameController,
                decoration: const InputDecoration(labelText: "Product Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter product name";
                  }
                  return null;
                },
              ),
              
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter price";
                  }

                  final price = double.tryParse(value);
                  if (price == null) {
                    return "Enter a valid number";
                  }

                  if (price < 0) {
                    return "Price can't be negative";
                  }

                  return null;
                },
              ),

              TextFormField(
                controller: stockController,
                decoration: const InputDecoration(labelText: "Stock"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter stock quantity";
                  }

                  final stock = int.tryParse(value);
                  if (stock == null) {
                    return "Enter a valid number";
                  }

                  if (stock < 0) {
                    return "Stock can't be negative";
                  }

                  return null;
                },
              ),


              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text(
                      "Back",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20),

                  Consumer<AddProductProvider>(builder: (context, addProduct, child) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if(addProduct.getResponse != '') {

                        final provider = Provider.of<AddProductProvider>(context, listen: false);

                        final message = provider.getResponse;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                        
                        productNameController.clear();
                        priceController.clear();
                        stockController.clear();
                        addProduct.clear();
                      }
                    });
                    return ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blueAccent,
                        ),
                        
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                  }),
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
