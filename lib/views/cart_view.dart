import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/login_viewmodel.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  bool _isLoading = false;
  String? _message;

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);
    final user = loginViewModel.loggedInUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Carrello')),
        body: Center(
          child: Text(
            'Devi effettuare il login per accedere al carrello.',
            style: TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Carrello')),
      body: Consumer<CartViewModel>(
        builder: (context, cartViewModel, child) {
          return Column(
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
                        onPressed: () async {
                          await cartViewModel.removeFromCart(product);
                          if (mounted) setState(() {});
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (cartViewModel.userEmail != null)
                      Text('Email: ${cartViewModel.userEmail!}', style: TextStyle(fontWeight: FontWeight.bold)),
                    if (_message != null)
                      Text(_message!, style: TextStyle(color: Colors.red)),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading || cartViewModel.userEmail == null
                          ? null
                          : () async {
                        setState(() => _isLoading = true);
                        final success = await cartViewModel.processPayment(cartViewModel.userEmail!);
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Pagamento effettuato!')),
                          );
                        }
                      },
                      child: _isLoading
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Text('Procedi al pagamento'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
