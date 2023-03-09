import 'package:flutter/material.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List patients = [];

  void _loadData() async {

    setState(() {
      patients = [];
    });
  }

  void _addPatient() async {
    
  }


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
                  Navigator.pushNamed(context, '/profile');
                },
                icon: const Icon(Icons.person),
              )
            ],
          ),
          body: Column(
            children: const [
              Center(child: Text(
                style: TextStyle(fontSize: 36),
                'Patient List')),
              Text('Patient 1')
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            tooltip: 'Add Patient',
            child: const Icon(Icons.add),
          ),
        ));
  }
}
