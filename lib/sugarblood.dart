import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:sato/detailsugarblood/sugarday.dart';
import 'package:sato/detailsugarblood/sugarmonth.dart';
import 'package:sato/detailsugarblood/sugarweek.dart';

class SugarbloodPage extends StatefulWidget {
  @override
  _SugarbloodPageState createState() => _SugarbloodPageState();
}

class _SugarbloodPageState extends State<SugarbloodPage>
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
    _tabController = TabController(length: 3, vsync: this);
    fetchData();
  }

  @override
  void dispose() {
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
      backgroundColor: Color.fromARGB(255, 255, 251, 138),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color.fromARGB(255, 255, 251, 138),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the start
              children: [
                Text(
                  userData.isNotEmpty
                      ? "นมัสการ ${userData['user_fname']}"
                      : 'Loading...',
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
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 35),
              child: TabBar(
                dividerColor: Colors.transparent,
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.black,
                controller: _tabController,
                tabs: const <Widget>[
                  Tab(
                    child: Text(
                      'Day',
                      style: TextStyle(fontSize: 18.0), // Increased font size
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Week',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Month',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  sugarday(),
                  Sugarweek(), // Placeholder for Week chart/widget
                  sugarmonth(), // Placeholder for Month chart/widget
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
