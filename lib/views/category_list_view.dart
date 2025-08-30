import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({Key? key}) : super(key: key);

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<ProductViewModel>(context, listen: false);
    viewModel.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isCategoriesLoading) {
          return Scaffold(
            appBar: AppBar(title: Text('Categorie')),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Categorie'),
            leading: IconButton(
              icon: Icon(Icons.home),
              tooltip: 'Home',
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView.builder(
            itemCount: viewModel.categories.length,
            itemBuilder: (context, index) {
              final category = viewModel.categories[index];
              return ListTile(
                title: Text(category),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/products',
                    arguments: category,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
