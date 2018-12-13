import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';
import 'home.dart' as home;

void main() {
  runApp(MyApp());
  const oneSecond = const Duration(seconds:30);
  new Timer.periodic(oneSecond, (Timer t) => (home.ChatScreenState().downloadList()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Login',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Login()
    );
  }
}