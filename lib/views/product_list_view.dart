import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../models/product.dart';

class ProductListView extends StatelessWidget {
  final String? category;
  const ProductListView({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProductViewModel>(context);
    final cartViewModel = Provider.of<CartViewModel>(context);
    final products = category == null
        ? viewModel.products
        : viewModel.productsByCategory(category!);
    return Scaffold(
      appBar: AppBar(
        title: Text(category == null ? 'Prodotti' : 'Prodotti: $category'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'Categorie',
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          )
        ],
      ),
      body: viewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _ProductListTile(product: product, cartViewModel: cartViewModel);
              },
            ),
    );
  }
}

class _ProductListTile extends StatefulWidget {
  final Product product;
  final CartViewModel cartViewModel;
  const _ProductListTile({required this.product, required this.cartViewModel});

  @override
  State<_ProductListTile> createState() => _ProductListTileState();
}

class _ProductListTileState extends State<_ProductListTile> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final avg = product.averageRating;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Image.network(product.image, width: 50, height: 50),
              title: Text(product.title),
              subtitle: Text('${product.price} €'),
            ),
            Row(
              children: [
                Text('Recensioni: '),
                if (avg != null)
                  Row(
                    children: List.generate(5, (i) => Icon(
                      i < avg.round() ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    )),
                  )
                else
                  Text('Nessuna recensione'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text('Quantità: '),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                ),
                Text('$quantity'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => setState(() => quantity++),
                ),
                Spacer(),
                ElevatedButton.icon(
                  icon: Icon(Icons.add_shopping_cart),
                  label: Text('Aggiungi'),
                  onPressed: () {
                    widget.cartViewModel.addToCart(product, quantity: quantity);
                    final snackBar = SnackBar(content: Text('Aggiunto $quantity x ${product.title} al carrello'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
