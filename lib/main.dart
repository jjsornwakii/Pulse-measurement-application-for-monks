import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:sato/login.dart';

import 'package:sato/navigation.dart';
import 'package:get_storage/get_storage.dart';



void main() async {
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GetStorage box = GetStorage();
  String? userId;

  @override
  void initState() {
    super.initState();

    final server = dotenv.env['server'] ?? '';
    final port = dotenv.env['port'] ?? '';
    final apipath = dotenv.env['apipath'] ?? '';
    chcekActivity();
    CheckLogin();
  }

  Future<void> chcekActivity() async {
    final server = dotenv.env['server'] ?? '';
    final port = dotenv.env['port'] ?? '';
    final apipath = dotenv.env['apipath'] ?? '';

    String apiUrl = 'http://$server:$port/shatu/setActiviy.php';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
          <String, String>{'user_id': box.read('userId').toString()}),
    );

    // Handle the response appropriately here
  }

  void CheckLogin() {
    userId = box.read("userId");
    print(userId);
    print('--------------------------');
    if (userId != null && userId!.isNotEmpty) {
      //chcekActivity(); // Fetch data if the user is logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: userId == null || userId == '' ? LoginPage() : NavigationPage(),
    );
  }
}
