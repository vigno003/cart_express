import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../models/cart_item.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Carrello')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartViewModel.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartViewModel.cartItems[index];
                final product = cartItem.product;
                final quantity = cartItem.quantity;
                final totalPrice = (product.price * quantity).toStringAsFixed(2);
                return ListTile(
                  leading: Image.network(product.image, width: 50, height: 50),
                  title: Text(product.title),
                  subtitle: Text('Quantità: $quantity\nTotale: $totalPrice €'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_shopping_cart),
                    onPressed: () => cartViewModel.removeFromCart(product),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email per la ricevuta',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: cartViewModel.cartItems.isEmpty
                            ? null
                            : () async {
                                setState(() {
                                  _isLoading = true;
                                  _message = null;
                                });
                                final email = _emailController.text.trim();
                                final result = await cartViewModel.processPayment(email);
                                setState(() {
                                  _isLoading = false;
                                  _message = result
                                      ? 'Pagamento riuscito! Riceverai una email.'
                                      : 'Errore nel pagamento o carrello vuoto.';
                                });
                                if (result) {
                                  cartViewModel.clearCart();
                                }
                              },
                        child: Text('Paga'),
                      ),
                if (_message != null) ...[
                  const SizedBox(height: 8),
                  Text(_message!, style: TextStyle(color: _message!.contains('riuscito') ? Colors.green : Colors.red)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
