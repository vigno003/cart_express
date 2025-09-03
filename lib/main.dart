import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/product_viewmodel.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/cart_viewmodel.dart';
import 'views/product_list_view.dart';
import 'views/cart_view.dart';
import 'views/home_view.dart';
import 'views/category_list_view.dart';
import 'views/login_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductViewModel()..fetchProducts()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProxyProvider<LoginViewModel, CartViewModel>(
          create: (_) => CartViewModel(),
          update: (_, loginVM, cartVM) {
            final username = loginVM.loggedInUser?.username;
            final newCartVM = CartViewModel(username: username);
            if (username != null) {
              newCartVM.loadCart();
            }
            return newCartVM;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cart Express',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => const HomeView(),
        '/categories': (context) => CategoryListView(),
        '/products': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args != null && args is String) {
            return ProductListView(category: args);
          }
          return ProductListView();
        },
        '/cart': (context) => CartView(),
        '/login': (context) => const LoginView(),
      },
    );
  }
}
