import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';

class SugarbloodPage extends StatefulWidget {
  @override
  _SugarbloodPageState createState() => _SugarbloodPageState();
}

class _SugarbloodPageState extends State<SugarbloodPage> {
  final GetStorage box = GetStorage();
  final server = dotenv.env['server'] ?? '';
  final port = dotenv.env['port'] ?? '';
  final apipath = dotenv.env['apipath'] ?? '';
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    // Load initial data or perform initialization tasks
    fetchData();
  }

  Future<void> fetchData() async {
    // Example function to fetch data from storage or API
    setState(() {
      userData = box.read('userData') ?? {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sugar Blood Page'),
      ),
      body: Center(
        child: userData.isEmpty
            ? Text('No data available')
            : Text('User Data: ${userData.toString()}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Example of updating data
          setState(() {
            userData['sugarBlood'] = '90 mg/dL';
            box.write('userData', userData);
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
