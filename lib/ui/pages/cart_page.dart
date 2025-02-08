import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:epsi_shop/bo/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    Future<void> proceedToPayment() async {
      final url = Uri.parse('https://thingproxy.freeboard.io/fetch/https://ptsv3.com/t/EPSISHOPC1/');
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({
        "articles": cart.allProducts.map((product) => {
          "name": product.title,
          "price": product.price,
        }).toList(),
        "total": cart.totalTTC,
        "currency": "EUR",
      });

      try {
        final response = await http.post(url, headers: headers, body: body);
        if (response.statusCode == 200) {
          cart.clearCart();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Paiement réussi!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors du paiement: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Panier"),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => context.go("/"),
          ),
        ],
      ),
      body: cart.isEmpty
          ? Center(child: Text("Votre panier est vide"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.allProducts.length,
              itemBuilder: (context, index) {
                final product = cart.allProducts[index];
                return ListTile(
                  leading: Image.network(product.image, width: 50),
                  title: Text(product.title),
                  subtitle: Text("${product.price}€ HT"),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () => cart.removeProduct(product),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Total TTC: ${cart.totalTTC.toStringAsFixed(2)}€",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 10),
                if (!cart.isEmpty)
                  ElevatedButton(
                    onPressed: proceedToPayment,
                    child: Text("Procéder au paiement"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}