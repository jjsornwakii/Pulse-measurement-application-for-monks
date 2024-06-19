import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';

class HeartRatePage extends StatefulWidget {
  @override
  _HeartRatePageState createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage> {
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
        title: Text('Heart Rate Page'),
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
            userData['heartRate'] = '72 bpm';
            box.write('userData', userData);
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() async {
  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize GetStorage
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HeartRatePage(),
    );
  }
}
