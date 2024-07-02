import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:sato/login.dart';
import 'package:flutter/services.dart';

import 'package:sato/navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sato/pinAuthen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await GetStorage.init();

  // ทำการตั้งค่าให้ซ่อน Navigation Bar และ Status Bar ก่อนที่แอปจะเริ่มทำงาน
  await WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
    CheckLogin();
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
      home: userId == null || userId == '' ? LoginPage() :NavigationPage() //Pinauthen(),
    );
  }
}
