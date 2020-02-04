import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:ku_connect/Loading/loading.dart';
import 'package:ku_connect/screens/Register.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  String pass = '';
  String code = '';
  String errorRegister = '';

  getData() async {
    Map<String, String> headers = {"Content-type": "application/json"};

    String body = '{"pass": "' + pass.trim() + '", "code": "' + code.trim() + '"}';
    print(body);
    Response response = await post('http://ku-connect.herokuapp.com/api/user/signin', headers: headers, body: body);

    Map<String, dynamic> resp = jsonDecode(response.body);

    if (resp["Error"] != null)
      setState(() {
        errorRegister = resp["Error"];
        loading = false;
      });
    else {
      setState(() {
        errorRegister = '';
        loading = false;
      });
      print(resp);
    }}

    @override
    Widget build(BuildContext context) {
        return loading ? Loading() : Scaffold(

          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.green[400],
            title: Text('Log In to KU-Connect'),
            actions: <Widget>[
              FlatButton.icon(
                  icon: Icon(Icons.person_add),
                  label: Text('Register'),
                  // Within the `FirstRoute` widget
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  }
              )
            ],
          ),

          body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'ID-Code'
                    ),
                    validator: (val) => val.isEmpty ? 'Enter ID-code' : null,
                    onChanged: (val) {
                      setState(() => code = val);
                      _formKey.currentState.validate();
                    },
                    onTap: () {
                      setState(() =>
                        errorRegister = ''
                      );
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: _obscureText,

                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        hintText: 'Password',
                        suffixIcon: IconButton(onPressed: _toggle,
                          icon: _obscureText
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        )
                    ),
                    validator: (val) => val.length !=4 ? 'Enter the 4 length pin' : null,
                    onChanged: (val) {
                      setState(() => pass = val);
                      _formKey.currentState.validate();
                    },
                    onTap: () {
                      setState(() => errorRegister = '');
                    },
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    color: Colors.red,
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(()=> loading = true);
                        getData();
                      }
                    },
                  ),
                SizedBox(height: 12.0),
                  Text(
                    errorRegister,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}