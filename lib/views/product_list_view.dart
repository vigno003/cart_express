import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/login_viewmodel.dart';
import '../models/product.dart';
import '../models/review.dart';

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
      child: InkWell(
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => ProductDetailOverlay(product: product),
        ),
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
      ),
    );
  }
}

class ProductDetailOverlay extends StatefulWidget {
  final Product product;
  const ProductDetailOverlay({required this.product});

  @override
  State<ProductDetailOverlay> createState() => _ProductDetailOverlayState();
}

class _ProductDetailOverlayState extends State<ProductDetailOverlay> {
  int selectedStars = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final reviews = product.reviews ?? [];
    final avg = product.averageRating;
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    final productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    final String? currentUser = loginViewModel.loggedInUser?.username;
    final userReview = currentUser != null
      ? (reviews.where((r) => r.username == currentUser).isNotEmpty
          ? reviews.firstWhere((r) => r.username == currentUser)
          : null)
      : null;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.network(product.image, width: 120, height: 120)),
              SizedBox(height: 12),
              Text(product.title, style: Theme.of(context).textTheme.titleLarge),
              Text('${product.price} €', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(product.description),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Media recensioni: '),
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
              SizedBox(height: 12),
              Text('Recensioni utenti:', style: TextStyle(fontWeight: FontWeight.bold)),
              if (reviews.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Nessuna recensione ancora.'),
                )
              else
                ...reviews.map((r) => ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (i) => Icon(
                      i < r.rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 18,
                    )),
                  ),
                  title: Text(r.username),
                  subtitle: r.text != null ? Text(r.text!) : null,
                  trailing: Text('${r.date.day}/${r.date.month}/${r.date.year}'),
                )),
              Divider(),
              if (userReview == null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lascia una recensione:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: List.generate(5, (i) => IconButton(
                        icon: Icon(i < selectedStars ? Icons.star : Icons.star_border, color: Colors.amber),
                        onPressed: () => setState(() => selectedStars = i + 1),
                      )),
                    ),
                    TextField(
                      controller: _reviewController,
                      decoration: InputDecoration(hintText: 'Scrivi un commento (opzionale)'),
                      maxLines: 2,
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: selectedStars > 0 && currentUser != null ? () {
                        final newReview = Review(
                          username: currentUser,
                          rating: selectedStars,
                          text: _reviewController.text.isNotEmpty ? _reviewController.text : null,
                          date: DateTime.now(),
                        );
                        productViewModel.addReviewToProduct(product.id, newReview);
                        Navigator.pop(context);
                      } : null,
                      child: Text('Invia'),
                    ),
                  ],
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Hai già lasciato una recensione.'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
