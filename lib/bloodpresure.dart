import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';

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
      title: 'Blood Pressure App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BloodPressurePage(),
    );
  }
}

class BloodPressurePage extends StatefulWidget {
  @override
  _BloodPressurePageState createState() => _BloodPressurePageState();
}

class _BloodPressurePageState extends State<BloodPressurePage> {
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

    // If you need to fetch data from a server
    // final response = await http.get(Uri.parse('$server:$port/$apipath'));
    // if (response.statusCode == 200) {
    //   setState(() {
    //     userData = json.decode(response.body);
    //     box.write('userData', userData);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Pressure Page'),
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
            userData['bloodPressure'] = '120/80';
            box.write('userData', userData);
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
