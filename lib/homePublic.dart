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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: const Image(
                      width: 200.0,
                      image: AssetImage('assets/images/clinic.png')),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: const Text(
                        style: TextStyle(fontSize: 36, color: Colors.black),
                        'Welcome to CLIMAN')),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: const Text(
                        style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 98, 98, 98)),
                        'A clinic management tool designed for doctors.')),
              ],
            ),
          ),
        ));
  }
}
