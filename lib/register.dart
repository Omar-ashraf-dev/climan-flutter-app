import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(const RegisterPage());
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController(text: '');
  final lastNameController = TextEditingController(text: '');
  final emailController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  final passwordConfirmController = TextEditingController(text: '');

  var statusMessage = 'Enter your information to sign up to CLIMAN';
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
                        'Sign up'),
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
                      controller: firstNameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'First Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Last Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Email'),
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
                          border: OutlineInputBorder(), hintText: 'Password'),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value != passwordConfirmController.text) {
                          return 'Passwords doesn\'t match';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: TextFormField(
                      controller: passwordConfirmController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Confrim Password'),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password confirm is required';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords doesn\'t match';
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
                          child: const Text('Sign up'))),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Already have an account?'),
                          TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/login'),
                              child: const Text('Sign in'))
                        ],
                      )),
                ]),
          ),
        ),
      ),
    );
  }

  postData() async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/register'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'email': emailController.text,
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'password': passwordController.text,
        'password2': passwordConfirmController.text
      }),
    );

    if (response.statusCode == 401) {
      setState(() {
        statusMessage = 'Invalid email or password';
        statusColor = Colors.red;
      });
    } else if (response.statusCode == 201) {
      Navigator.pushNamed(context, '/');
    } else {
      var data = json.decode(response.body);
      if (data['email'] != null) {
        if (data['email'][0] == 'This field must be unique.') {
          setState(() {
            statusMessage = 'Email already in use. Enter another email.';
            statusColor = Colors.red;
          });
        }
      }
      else {
        setState(() {
          statusMessage = 'Something went wrong. Try again.';
          statusColor = Colors.red;
        });
      }
    }
  }
}
