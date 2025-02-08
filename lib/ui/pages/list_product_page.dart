import 'dart:convert';

import 'package:epsi_shop/bo/product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:epsi_shop/bo/cart.dart';

class ListProductPage extends StatefulWidget {
  @override
  _ListProductPageState createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse("https://fakestoreapi.com/products"));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        products = jsonData.map((data) => Product.fromMap(data)).toList();
        isLoading = false;
      });
    }
    return Future.error("Erreur de téléchargement");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("EPSI Shop"),
        actions: [
          IconButton(
            onPressed: () => context.go("/cart"),
            icon: Badge(
              label:
              Text(context.watch<Cart>().allProducts.length.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            leading: Image.network(product.image, width: 50, height: 50),
            title: Text(product.title),
            subtitle: Text(product.getPrice()),
            onTap: () {
              context.go("/detail/${product.id}");
            },
          );
        },
      ),
    );
  }
}

class ListViewProducts extends StatelessWidget {
  const ListViewProducts({
    super.key,
    required this.listProducts,
  });

  final List<Product> listProducts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listProducts.length,
        itemBuilder: (ctx, index) => InkWell(
              onTap: () => ctx.go("/detail/${listProducts[index].id}"),
              // /detail/4
              child: ListTile(
                leading: Image.network(
                  listProducts[index].image,
                  width: 90,
                  height: 90,
                ),
                title: Text(listProducts[index].title),
                subtitle: Text(listProducts[index].getPrice()),
              ),
            ));
  }
}
