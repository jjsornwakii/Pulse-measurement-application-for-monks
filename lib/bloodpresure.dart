import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sato/detailbloodpresure/bloodpresureday.dart';
import 'package:sato/detailbloodpresure/bloodpresuremonth.dart';
import 'package:sato/detailbloodpresure/bloodpresureweek.dart';
import 'package:http/http.dart' as http;

void main() async {
  // Ensure WidgetsBinding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize GetStorage
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Pressure App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BloodPressurePage(),
    );
  }
}

class BloodPressurePage extends StatefulWidget {
  const BloodPressurePage({super.key});

  @override
  _BloodPressurePageState createState() => _BloodPressurePageState();
}

class _BloodPressurePageState extends State<BloodPressurePage>
    with SingleTickerProviderStateMixin {
  final GetStorage box = GetStorage();
  final String server = dotenv.env['server'] ?? '';
  final String port = dotenv.env['port'] ?? '';
  final String apipath = dotenv.env['apipath'] ?? '';
  Map<String, dynamic> userData = {};
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize the TabController
    _tabController = TabController(length: 3, vsync: this);
    fetchData();
  }

  @override
  void dispose() {
    // Dispose of the TabController when the widget is disposed
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    final url = 'http://$server:$port/$apipath/userinfo.php';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'user_id': box.read('userId')}),
    );

    if (response.statusCode == 200) {
      setState(() {
        userData = jsonDecode(response.body);
      });
    } else {
      print('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 251, 138),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color.fromARGB(255, 255, 251, 138),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  (userData != null &&
                          userData!['user_fname'] != null &&
                          userData!['user_fname'] != "null")
                      ? "นมัสการ ${userData['user_fname']}"
                      : 'นมัสการ ชื่อ...',
                  style: GoogleFonts.kanit(color: Colors.black, fontSize: 30),
                ),
                Text(
                  "ภาพรวมสุขภาพ",
                  style: GoogleFonts.kanit(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.orange,
                      width: 2.0,
                    ),
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.person,
                      color: Colors.orange,
                      size: 45,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(),
              margin: const EdgeInsets.symmetric(horizontal: 35),
              child: TabBar(
                dividerColor: Colors.transparent,
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.black,
                controller: _tabController,
                tabs: const <Widget>[
                  Tab(
                    child: Text(
                      'วัน',
                      style: TextStyle(fontSize: 18.0), // Increased font size
                    ),
                  ),
                  Tab(
                    child: Text(
                      'สัปดาห์',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'เดือน',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const <Widget>[
                  // chartColumn(),
                  // Chartjah(),
                  // Monthchart(),
                  // Yearschart()
                  Bloodpresureday(),
                  Bloodpresureweek(),
                  Bloodpresuremonth(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
