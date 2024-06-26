import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sato/detailHeartRate/chartHeartDay.dart';
import 'package:sato/detailHeartRate/chartHeartMonth.dart';
import 'package:sato/detailHeartRate/chartHeartWeek.dart';
import 'package:http/http.dart' as http;

void main() async {
  // Ensure WidgetsBinding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize GetStorage
  await GetStorage.init();
}

class HeartRatePage extends StatefulWidget {
  @override
  _HeartRatePageState createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage>
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
      backgroundColor: Color(0xFFFFFDC8),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color(0xFFFFFDC8),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          tooltip: 'Go Back',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (userData != null &&
                          userData!['user_fname'] != null &&
                          userData!['user_fname'] != "null")
                      ? "นมัสการ, ${userData!['user_fname']}"
                      : 'นมัสการ, ชื่อ...',
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
                  child: CircleAvatar(
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
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(),
              margin: EdgeInsets.symmetric(horizontal: 35),
              child: TabBar(
                dividerColor: Colors.transparent,
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.black,
                controller: _tabController,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      'วัน',
                      style: GoogleFonts.kanit(
                          fontSize: 18.0), // Increased font size
                    ),
                  ),
                  Tab(
                    child: Text(
                      'สัปดาห์',
                      style: GoogleFonts.kanit(fontSize: 18.0),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'เดือน',
                      style: GoogleFonts.kanit(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const <Widget>[
                  Chartheartday(),
                  Chartheartweek(),
                  Chartheartmonth(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
