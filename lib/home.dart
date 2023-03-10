// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Gender { male, female }

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: '');
  final emailController = TextEditingController(text: '');
  final phoneController = TextEditingController(text: '');
  var genderValue = '';

  var statusMessage = 'Enter your patient information';
  var statusColor = Colors.grey;

  Gender? _gender = Gender.male;

  List patients = [];

  void _loadData() async {
    var response = await http.get(
      Uri.parse('http://10.0.2.2:8000/patients'),
    );

    setState(() {
      patients = jsonDecode(response.body);
    });
  }

  void _addPatient() async {
    var body = jsonEncode({
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'gender': genderValue,
      'user':
          1 // Hard cooded until verifying backend to send/recieve data for single user
    });

    var response = await http.post(Uri.parse('http://10.0.2.2:8000/patients'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: body);

    if (response.statusCode == 201) {
      _loadData();
      Navigator.pop(context);
    } else {
      var data = json.decode(response.body);
      //print(data['phone'][0]);
      if (data['email'] != null) {
        print(data['email'][0]);
        if (data['email'][0] == 'patient with this email already exists.') {
          setState(() {
            statusMessage = 'Patient with this email already exists.';
            statusColor = Colors.red;
          });
        }
      } else if (data['phone'] != null) {
        print(data['phone'][0]);
        if (data['phone'][0] == 'patient with this phone already exists.') {
          setState(() {
            statusMessage = 'Patient with this phone already exists.';
            statusColor = Colors.red;
          });
        }
      } else {
        setState(() {
          statusMessage = 'Something went wrong. Try again.';
          statusColor = Colors.red;
        });
      }
    }
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: const Text(
                          style: TextStyle(fontSize: 42), 'Patient List')),
                ),
                Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Column(
                      children: <Widget>[
                        for (var patient in patients)
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patient['name'],
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(patient['email'],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400)),
                                  Text(patient['phone'],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400)),
                                  patient['gender'] == 'M'
                                      ? const Text('Male',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400))
                                      : const Text('Female',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400)),
                                  const Divider(
                                    color: Colors.grey,
                                  ),
                                ]),
                          )
                      ],
                    )),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: Stack(
                          //overflow: Overflow.visible,
                          children: <Widget>[
                            Positioned(
                                right: -40.0,
                                top: -40.0,
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.close),
                                  ),
                                )),
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 5.0, 0, 5.0),
                                      child: Text(
                                          style: TextStyle(
                                              fontSize: 14, color: statusColor),
                                          statusMessage)),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 5.0, 0, 5.0),
                                    child: TextFormField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        label: Text('Full Name'),
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Name is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 2.0, 0, 5.0),
                                    child: TextFormField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        label: Text('Email'),
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Email is required';
                                        }
                                        if (!value.contains('@') ||
                                            !value.contains('.')) {
                                          return 'Invalid email address';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 2.0, 0, 5.0),
                                    child: TextFormField(
                                      controller: phoneController,
                                      decoration: const InputDecoration(
                                        label: Text('Phone Number'),
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Phone number is required';
                                        }
                                        if (value.substring(0, 2) == '010' ||
                                            value.substring(0, 2) == '011' ||
                                            value.substring(0, 2) == '012' ||
                                            value.substring(0, 2) == '015' ||
                                            value.length == 11) {
                                          return null;
                                        } else {
                                          return 'Invalid phone number';
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 2.0, 0, 5.0),
                                      child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            label: const Text('Gender'),
                                            border: const OutlineInputBorder(),
                                            hintStyle: TextStyle(
                                                color: Colors.grey[800]),
                                            hintText: "Gender",
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Gender is required';
                                            }
                                            return null;
                                          },
                                          items: <String>['Male', 'Female']
                                              .map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (_value) {
                                            setState(() {
                                              if (_value == 'Male') {
                                                genderValue = 'M';
                                              } else {
                                                genderValue = 'F';
                                              }
                                            });
                                          })),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 2.0, 0, 5.0),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _addPatient();
                                            }
                                          },
                                          child: const Text('Submit'))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            tooltip: 'Add Patient',
            child: const Icon(Icons.add),
          ),
        ));
  }
}
