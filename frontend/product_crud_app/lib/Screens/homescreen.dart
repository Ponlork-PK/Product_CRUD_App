import 'package:flutter/material.dart';
import 'package:product_crud_app/Provider/delete_product_provider.dart';
import 'package:provider/provider.dart';
import 'package:product_crud_app/Provider/get_product_provider.dart';
import 'package:product_crud_app/Screens/Pages/add_product_page.dart';
import 'package:product_crud_app/Screens/Pages/edit_product_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch product list when screen loads
    Provider.of<GetProductProvider>(context, listen: false).fetchProducts();
  }

  Future<void> _refreshProducts() async {
    await Provider.of<GetProductProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Product List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            width: 45,
            height: 45,
            margin: const EdgeInsets.only(right: 20),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 41, 0, 204),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add),
              color: Colors.white,
              onPressed: () async {
                final refresh = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddProductPage()),
                );
                
                if(refresh == true) {
                  await _refreshProducts();
                }
              },
            ),
          ),
        ],
        backgroundColor: Colors.blueAccent,
      ),

      body: Consumer<GetProductProvider>(
        builder: (context, provider, child) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('No product found.'),
                  Text('Add your first product.'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshProducts,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ListView(
                children: List.generate(
                  provider.products.length, 
                  (index) {
                    final product = provider.products[index];
                    return Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            offset: const Offset(0, 3),
                          ),
                        ]
                      ),
                      child: Card(
                        color: Colors.white,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              //  Display product info
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.productName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  Text("Price: \$${product.price}"),
                                  Text("Stock: ${product.stock}"),
                                ],
                              ),

                              //  Action Buttons
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditProductPage(
                                            productId: product.productId,
                                            productName: product.productName,
                                            price: product.price,
                                            stock: product.stock,
                                          ),
                                        ),
                                      );

                                      // Refresh after returning from EditProductPage
                                      _refreshProducts();
                                    },
                                    
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      backgroundColor: Colors.blueAccent,
                                    ),
                                    child: const Icon(Icons.edit, color: Colors.white),
                                  ),
                                  const SizedBox(height: 5),
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text("Confirm Message"),
                                          content: const Text("Do you want to delete this product?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(ctx),
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(ctx);
                                                Provider.of<DeleteProductProvider>(context, listen: false)
                                                    .deleteProduct(product.productId)
                                                    .then((_) {
                                                  final msg = Provider.of<DeleteProductProvider>(context, listen: false).response;
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                                    
                                                  // Refresh after delete
                                                  _refreshProducts();
                                                });
                                              },
                                              child: const Text("Yes", style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Icon(Icons.delete, color: Colors.white),
                                  ),
                                    
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } 
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
