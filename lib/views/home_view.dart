import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    final response = await http.get(Uri.parse('https://zenquotes.io/api/random'));
    final data = json.decode(response.body);
    if (data is List && data.isNotEmpty && data[0]['q'] != null && data[0]['a'] != null) {
      if ((data[0]['q'] as String).toLowerCase().contains('too many requests')) {
        setState(() {
          _error = 'Hai richiesto troppe citazioni. Riprova più tardi.';
          _loading = false;
        });
      } else {
        setState(() {
          _quote = data[0]['q'];
          _author = data[0]['a'];
          _loading = false;
        });
      }
    } else {
      setState(() {
        _error = 'Errore sconosciuto.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benvenuti su ProductExpress'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_loading)
              const CircularProgressIndicator()
            else if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red))
            else if (_quote != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
              child: const Text('Vai al carrello'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _fetchQuote();
              },
              child: const Text('Nuova citazione'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/categories');
              },
              child: const Text('Vai alle categorie'),
            ),
            const SizedBox(height: 16),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
