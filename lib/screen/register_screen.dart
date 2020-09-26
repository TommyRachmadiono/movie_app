import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_app/utils/custom_style.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/utils/network_url.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _rePasswordController = TextEditingController();

  bool _isLoading = false;
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void check() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _isLoading = true;
      });
      submitDataRegister();
    }
  }

  submitDataRegister() async {
    try {
      final response = await http.post("$NETWORK_URL/register-mobile", body: {
        "email": _emailController.text,
        "password": _passwordController.text,
        "name": _nameController.text,
      });

      final data = jsonDecode(response.body);
      int value = data['value'];
      String msg = data['msg'];
      String error = data['error'];

      if (value == 1) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
        _emailController.text = '';
        _passwordController.text = '';
        _rePasswordController.text = '';
        _nameController.text = '';
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error)));
        print(msg);
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.cyan[200],
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('REGISTER PAGE', style: authTitleStyle),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          validator: (value) => value.trim().isEmpty
                              ? 'Email tidak boleh kosong'
                              : null,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(
                              Icons.email,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _nameController,
                          validator: (value) => value.trim().isEmpty
                              ? 'Nama tidak boleh kosong'
                              : null,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) => value.trim().isEmpty
                              ? 'Password tidak boleh kosong'
                              : null,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _rePasswordController,
                          validator: (value) {
                            if (value.trim() != _passwordController.text)
                              return 'Konfirmasi password harus sama dengan password';
                            if (value.trim().isEmpty)
                              return 'Konfirmasi password tidak boleh kosong';
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: Icon(
                              Icons.lock,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          child: _isLoading
                              ? SpinKitThreeBounce(
                                  color: Colors.blue,
                                )
                              : RaisedButton(
                                  onPressed: check,
                                  color: Colors.cyan,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text('Sign Up'),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have account ? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sign In',
                        style: authLinkText,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
