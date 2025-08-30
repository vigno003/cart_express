import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';

class CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProductViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Carrello')),
      body: ListView.builder(
        itemCount: viewModel.cart.length,
        itemBuilder: (context, index) {
          final product = viewModel.cart[index];
          return ListTile(
            leading: Image.network(product.image, width: 50, height: 50),
            title: Text(product.title),
            subtitle: Text('${product.price} €'),
            trailing: IconButton(
              icon: Icon(Icons.remove_shopping_cart),
              onPressed: () => viewModel.removeFromCart(product),
            ),
          );
        },
      ),
    );
  }
}

