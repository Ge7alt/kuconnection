import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ku_connect/Loading/loading.dart';
import 'package:http/http.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool loading = false;

  String name = '';
  String email = '';
  String code = '';
  String errorRegister = '';

  getData() async {
    Map<String, String> headers = {"Content-type": "application/json"};

    String body = '{"name": "' + name.trim() + '", "email": "' + email.trim() + '", "code": "' + code.trim() + '"}';
    print(body);
    Response response = await post('http://ku-connect.herokuapp.com/api/user/create', headers: headers, body: body);

    Map<String, dynamic> resp = jsonDecode(response.body);

    if(resp["Error"] != null)
      setState(() {
        errorRegister = resp["Error"];
      });
    else {
      setState(() {
        errorRegister = '';
      });
      Map<String, dynamic> token = resp["user"]["token"];
      int pass = resp["pass"];
      print("Passcode: ");
      print(pass);
      print(token);
    }

    print(response.body);
    print(response.statusCode);
  }


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :  Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text('Join KU Connect'),

      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(

          child: Column(
            children: <Widget>[

              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Your Name'
                ),
                onChanged: (val){
                  setState(() => name = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'E-mail'
                ),
                onChanged: (val){
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.branding_watermark),
                    hintText: 'ID-Code'
                ),
                onChanged: (val){
                  setState(() => code = val);
                },
              ),

              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.red,
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: (){
                getData();
                }
              ),
              Text(
                errorRegister,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


