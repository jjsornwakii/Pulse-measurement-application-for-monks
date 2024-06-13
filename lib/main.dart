import 'package:flutter/material.dart';
import 'package:sato/homepage.dart';
import 'package:sato/login.dart';
import 'package:sato/navigation.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GetStorage box = GetStorage();
  String? userId;
  @override
  void initState() {
    super.initState();
    CheckLogin();
  }

  void CheckLogin() {
    userId = box.read("userId");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: userId == null || userId == '' ? LoginPage() : NavigationPage(),
    );
  }
}
