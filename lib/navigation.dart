import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sato/ActivitiesPage.dart';

import 'package:sato/homepage.dart';
import 'package:sato/TipsHealthPage.dart';
import 'package:sato/userPage.dart';
import 'package:sato/healthPage.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NavigationPage(),
    );
  }
}

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 1;
  String? server = dotenv.env['server'];
  String? port = dotenv.env['port'];
  String? apipath = dotenv.env['apipath'];
  GetStorage box = GetStorage();
  Map<String, dynamic>? userData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _pages = <Widget>[
    Menu(),
    HomePage(),
    UserPage(),
    HealthPage(),
    ActivitiesPage(),
    TipsHealthPage(),
  ];

  List<Widget> _drawerPages = <Widget>[
    HealthPage(),
    ActivitiesPage(),
    TipsHealthPage(),
  ];

  @override
  void initState() {
    super.initState();
    print(box.read("userId"));
    _getUserData();
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      _scaffoldKey.currentState?.openDrawer();
    } else if (index == 2) {
      // Navigate to UserPage when "Person" is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _getUserData() async {
    final url = 'http://$server:$port/api_shatu/userinfo.php';
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

  void _onDrawerItemTapped(int index) {
    Navigator.pop(context);
    setState(() {
      _selectedIndex = 3 + index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 251, 138),
      key: _scaffoldKey,
      drawer: Container(
        margin: const EdgeInsets.fromLTRB(0, 130, 0, 0),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          bottom: BorderSide(width: 2.0, color: Colors.black),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.home,
                            size: 40,
                            color: Colors.orange,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'หน้าหลัก                  ',
                            style: GoogleFonts.kanit(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.broken_image_outlined,
                  size: 30,
                  color: Color.fromARGB(255, 215, 130, 2),
                ),
                title: Text('สรุปภาพรวมสุขภาพ',
                    style: GoogleFonts.kanit(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
                onTap: () {
                  _onDrawerItemTapped(0);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => HealthPage(),
                  //   ),
                  // );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.access_time,
                  size: 30,
                  color: Color.fromARGB(255, 215, 130, 2),
                ),
                title: Text('กิจประจำวัน',
                    style: GoogleFonts.kanit(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ActivitiesPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.local_library_sharp,
                  size: 30,
                  color: Color.fromARGB(255, 215, 130, 2),
                ),
                title: Text('เกร็ดน่ารู้เรื่องสุขภาพ',
                    style: GoogleFonts.kanit(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
                onTap: () {
                  _onDrawerItemTapped(2);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => TipsHealthPage()),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 251, 138),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Text(
                      userData != null
                          ? "นมัสการ ${userData!['user_fname']}"
                          : 'Loading...',
                      style:
                          GoogleFonts.kanit(color: Colors.black, fontSize: 30),
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
                const Column(
                  children: [
                    SizedBox(height: 50),
                    CircleAvatar(
                      maxRadius: 25,
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      child: Icon(
                        Icons.person,
                        color: Colors.orange,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages + _drawerPages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Person',
            ),
          ],
          currentIndex: _selectedIndex >= 3 ? 0 : _selectedIndex,
          selectedItemColor: Colors.amber[800],
          backgroundColor: Color.fromARGB(255, 250, 235, 235),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is menu Page'),
    );
  }
}
