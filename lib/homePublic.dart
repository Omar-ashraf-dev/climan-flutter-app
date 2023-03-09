import 'package:flutter/material.dart';

void main() {
  runApp(const HomePublicPage());
}

class HomePublicPage extends StatefulWidget {
  const HomePublicPage({super.key});

  @override
  State<HomePublicPage> createState() => _HomePublicPageState();
}

class _HomePublicPageState extends State<HomePublicPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('CLIMAN'),
            actions: <Widget>[
              IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      icon: const Icon(Icons.login),
                    )
            ],
          ),
          body: const Center(
              child: Text('Login to view you profile.'),
          ),
        ));
  }
}
