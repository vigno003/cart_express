import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cart_express/services/zenquotes_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? _quote;
  String? _author;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchQuote();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchQuote() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await ZenQuotesService.fetchQuote();
    if (result['error'] != null) {
      setState(() {
        _error = result['error'];
        _loading = false;
      });
    } else {
      setState(() {
        _quote = result['quote'];
        _author = result['author'];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    tooltip: 'Logout',
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.blue),
                    tooltip: 'Carrello',
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                ],
              ),
            ),
            // Titolo centrato con Montserrat
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  Text(
                    'ProductExpress',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'il vostro negozio di fiducia',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            // Spazio extra sotto titolo e sottotitolo
            const SizedBox(height: 56),
            // Bottone categorie grande e squadrato
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/categories');
                  },
                  child: const Text('Vai alle categorie'),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Citazione sotto il bottone categorie
            if (_loading)
              const CircularProgressIndicator()
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              )
            else if (_quote != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  children: [
                    Text(
                      '"$_quote"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '- $_author',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            // Bottone nuova citazione meno evidente
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextButton(
                onPressed: _fetchQuote,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  textStyle: const TextStyle(fontSize: 14),
                ),
                child: const Text('Nuova citazione'),
              ),
            ),
            // Spacer per riempire lo spazio
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
