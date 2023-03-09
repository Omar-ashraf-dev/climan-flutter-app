import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:jwt_decode/jwt_decode.dart';

void main() {
  runApp(const LoginPage());
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  var statusMessage = 'Enter your email and password to sign in to CLIMAN';
  var statusColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue),
                        'Sign in'),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: Text(
                        style: TextStyle(fontSize: 14, color: statusColor),
                        statusMessage),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        label: Text('Email'),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Invalid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        label: Text('Password'),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                      ),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              postData();
                            }
                          },
                          child: const Text('Sign in'))),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('New to CLIMAN?'),
                          TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/register'),
                              child: const Text('Sign up'))
                        ],
                      )),
                ]),
          ),
        ),
      ),
    );
  }

  postData() async {
    setState(() {
      statusMessage = '';
    });
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/token'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'email': emailController.text,
        'password': passwordController.text
      }),
    );
    if (response.statusCode == 401) {
      setState(() {
        statusMessage = 'Invalid email or password';
        statusColor = Colors.red;
      });
    } else if (response.statusCode == 200) {
      var token = jsonDecode(response.body)['access'];
      Map<String, dynamic> payload = Jwt.parseJwt(token);

      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      new Directory(appDocDirectory.path + '/' + 'data')
          .create(recursive: true);

      new File(appDocDirectory.path + '/' + 'data/' + 'tokenData.txt')
          .create(recursive: true)
          .then((File file) async {
        file.writeAsString(
          payload['full_name'] + '\n' + payload['email']
        );
      });

      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/home');
    } else {
      setState(() {
        statusMessage = 'Something went wrong. Try again.';
        statusColor = Colors.red;
      });
    }
  }
}
