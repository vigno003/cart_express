import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';

class ProductListView extends StatelessWidget {
  final String? category;
  const ProductListView({Key? key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProductViewModel>(context);
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
                return ListTile(
                  leading: Image.network(product.image, width: 50, height: 50),
                  title: Text(product.title),
                  subtitle: Text('${product.price} €'),
                  trailing: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () => viewModel.addToCart(product),
                  ),
                );
              },
            ),
    );
  }
}
