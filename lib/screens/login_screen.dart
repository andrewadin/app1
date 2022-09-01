import 'dart:convert';
import 'dart:ui';

import 'package:app1/screens/drug_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>{
  String errormsg = '';
  String _email = '', _password = '', apiurl = '';
  static String token = '';
  bool error = false;

  final _formkey = GlobalKey<FormState>();

  startLogin() async {
    if(kIsWeb){
      apiurl = "http://127.0.0.1:8000/api/login";
    }else{
      apiurl = "http://10.0.2.2:8000/api/login";
    }

    var response = await http.post(Uri.parse(apiurl), body: {
      'email' : _email,
      'password' : _password,
    });
    var jsondata = jsonDecode(response.body);
    if(response.statusCode == 200){
      token = jsondata['data']['token'];
      error = false;
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => const DrugScreen()));
    }else{
      setState(() {
        error = true;
        errormsg = jsondata['data']['error'];
      });
    }
    
  }

  Widget buildUsername(){
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.account_circle_sharp,
        color: Colors.lightBlue,
        size: 40,)),
        validator: (value){
          if(value == null || value.isEmpty){
            return 'Insert your credentials';
          }
        },
        onSaved: (value){
          _email = value.toString();
        },
      );
  }

  Widget buildPassword(){
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock,
        color: Colors.lightBlue,
        size: 40,)),
        obscureText: true,
        validator: (value){
          if(value == null || value.isEmpty){
            return 'Insert your credentials';
          }
        },
        onSaved: (value){
          _password = value.toString();
        },
      );
  }

  Widget buildSignUpButton(){
    return GestureDetector(
      onTap: (){
        print("Sign Up");
      },
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: "Don\'t have an account?",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w500
              )
            ),
            TextSpan(
              text: "Sign up here",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            )
          ]
        ) ),
    );
  }

  Widget errmsg(String text){
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.red,
        border: Border.all(color: Colors.red, width: 3)
      ),
      child: Row(children: [
        Container(
          margin: const EdgeInsets.only(right: 6),
          child: const Icon(Icons.info, color: Colors.white),
        ),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 18),)
      ],),
    );
  }

  Widget build(BuildContext context){
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/graphics/hospital_front.jpg'),
          fit: BoxFit.cover)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Help Me!'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.all(24),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 170),
                      const Text('Login to ask for help',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                      const SizedBox(height: 50),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.6)
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              padding: const EdgeInsets.all(10),
                              child: error? errmsg(errormsg):Container(),
                            ),
                            const SizedBox(height: 50,),
                            buildUsername(),
                            const SizedBox(height: 25,),
                            buildPassword(),
                            const SizedBox(height: 50,),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.lightBlue,
                                  padding: const EdgeInsets.all(18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)
                                  )
                                ),
                                onPressed: (){
                                  if(_formkey.currentState!.validate()){
                                    _formkey.currentState!.save();
                                  }
                                  startLogin();
                                },
                                child: const Text('Login',
                                style: TextStyle(fontSize: 20),),
                              ),
                            ),
                            const SizedBox(height: 25,),
                            buildSignUpButton(),
                          ],
                        ),
                      )
                    ],
                  )),
              )
            ],
          ),
        ),
      ),
    );
  }
}