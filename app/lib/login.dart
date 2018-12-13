import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

String email;
String password;

enum FormMode {
  SIGNIN, 
  SIGNUP
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new LoginState();
}

class LoginState extends State<Login> {
  FormMode formMode = FormMode.SIGNIN;
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Login'),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              sizedBox(50.0),
              sizedBox(100.0),
              emailInput(),
              sizedBox(15.0),
              passwordInput(),
              sizedBox(30.0),
              submitButton(),
              label(),
            ],
          ),
        ),
      ),
    );
  }
  Widget sizedBox(height) {
    return new SizedBox(height: height);
  }

  Widget emailInput() {
    return new TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: new InputDecoration(
        hintText: 'Email',
        icon: new Icon(
          Icons.mail,
          color: Colors.grey,
        )
      ),
      validator: (value) => value.isEmpty ? 'Email cannot be empty' : null,
      onSaved: (value) => email = value,
    );
  }

  Widget passwordInput() {
    return new TextFormField(
      obscureText: true,
      autofocus: false,
      decoration: new InputDecoration(
        hintText: 'Password',
        icon: new Icon(
          Icons.lock,
          color: Colors.grey,
        )
      ),
      validator: (value) => value.isEmpty ? 'Password cannot be empty' : null,
      onSaved: (value) => password = value,
    );
  }

  Widget submitButton() {
    if(formMode == FormMode.SIGNIN) {
      return
        new Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: new Material(
            borderRadius: BorderRadius.circular(30.0),
            shadowColor: Colors.blueAccent.shade100,
            elevation: 5.0,
            child: new MaterialButton(
              minWidth: 200.0,
              height: 42.0,
              color: Colors.blue,
              child: new Text('Login',
                style: 
                  new TextStyle(fontSize: 20.0, color: Colors.white)),
                  onPressed: validateAndSubmit,
            ),
          ),
        );
    } else {
      return 
        new Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: new Material(
            shadowColor: Colors.lightBlueAccent.shade100,
            borderRadius: BorderRadius.circular(30.0),
            elevation: 5.0,
            child: new MaterialButton(
              minWidth: 200.0,
              height: 42.0,
              color: Colors.blue,
              child: new Text('Create account',
                style:
                  new TextStyle(fontSize: 20.0, color: Colors.white)),
                onPressed: validateAndSubmit,
            ),
          ),
        );
    }
  }

  Widget label() {
    if(formMode == FormMode.SIGNIN) {
      return
        new FlatButton(
          child: new Text('Create an account',
            style:
              new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w300
              )
            ),
            onPressed: signUp,
        );
    } else {
      return
        new FlatButton(
          child: new Text('Have an account? Sign in',
            style: 
              new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w300
              ),
          ),
          onPressed: signIn,
        );
    }
  }

  void signUp() {
    formKey.currentState.reset();
    setState(() {
      formMode = FormMode.SIGNUP;
    });
  }

  void signIn() {
    formKey.currentState.reset();
    setState(() {
      formMode = FormMode.SIGNIN;
    });
  }

  bool validateAndSave() {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        return true;
      }
      return false;
    }

  void validateAndSubmit() async {
    if(validateAndSave()) {
      try {
        var j;
        if(formMode == FormMode.SIGNIN) {
          var url = "https://counterproducktivechat.tk:8448/_matrix/client/r0/login";
          http.post(url, body: '{"type":"m.login.password", "user":"sam", "password":"password1234"}').then((response) {
            j = json.decode(response.body)['access_token'];
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home(j)),
          );
        } else {
        }
      } catch (e) {
        print('Error $e');
      }
    }
  }
}