import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const ProfilePage());
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? email;

  void _loadData() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    final file = File('$path/data/tokenData.txt');
    final _loadedData = await file.readAsLines();

    setState(() {
      name = _loadedData[0];
      email = _loadedData[1];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(size: 200.0, Icons.person),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.w500),
                        'Name: '),
                    Text(
                        style: const TextStyle(fontSize: 36),
                        name ?? 'Name not loaded'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                        'Email: '),
                    Text(
                        style: const TextStyle(fontSize: 24),
                        email ?? 'Email not loaded'),
                  ],
                ),
              ],
            ))));
  }
}
