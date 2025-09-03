import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Carrello')),
      body: ListView.builder(
        itemCount: cartViewModel.cartItems.length,
        itemBuilder: (context, index) {
          final product = cartViewModel.cartItems[index];
          return ListTile(
            leading: Image.network(product.image, width: 50, height: 50),
            title: Text(product.title),
            subtitle: Text('${product.price} €'),
            trailing: IconButton(
              icon: Icon(Icons.remove_shopping_cart),
              onPressed: () => cartViewModel.removeFromCart(product),
            ),
          );
        },
      ),
    );
  }
}
