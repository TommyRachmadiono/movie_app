import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/screen/homepage_screen.dart';
import 'package:movie_app/screen/register_screen.dart';
import 'package:movie_app/utils/custom_style.dart';
import 'package:movie_app/utils/network_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isLogin = false;

  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void check() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _isLoading = true;
      });
      submitDataLogin();
    }
  }

  submitDataLogin() async {
    try {
      final response = await http.post("$NETWORK_URL/login-mobile", body: {
        "email": _emailController.text,
        "password": _passwordController.text,
      });

      final data = jsonDecode(response.body);
      int value = data['value'];
      String msg = data['msg'];

      if (value == 1) {
        int userId = data['user']['id'];
        String userName = data['user']['name'];
        String userEmail = data['user']['email'];

        setState(() {
          _isLogin = true;
          saveDataPref(value, userId, userName, userEmail);
        });
      } else {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Email atau Password salah')));
        print(msg);
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  saveDataPref(int value, int userId, String userName, String userEmail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('value', value);
    pref.setInt('userId', userId);
    pref.setString('userEmail', userEmail);
    pref.setString('userName', userName);
  }

  getDataPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      int value = pref.getInt('value');
      _isLogin = value == 1 ? true : false;
    });
  }

  signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = '';
      _passwordController.text = '';
      pref.clear();
      _isLogin = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getDataPref();
  }

  @override
  Widget build(BuildContext context) {
    return _isLogin
        ? HomePageScreen(signOut)
        : Scaffold(
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
                          child: Text('LOGIN PAGE', style: authTitleStyle),
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
                              _isLoading
                                  ? SpinKitThreeBounce(
                                      color: Colors.blue,
                                    )
                                  : Container(
                                      width: double.infinity,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        onPressed: check,
                                        color: Colors.cyan,
                                        child: Text('Sign In'),
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
                          Text("Don't have account ? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ));
                            },
                            child: Text('Sign Up', style: authLinkText),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
