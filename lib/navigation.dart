import 'package:flutter/material.dart';
import 'package:sato/homepage.dart';
import 'package:sato/userPage.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 1;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _pages = <Widget>[
    Menu(),
    HomePage(),
    UserPage(),
  ];

  List<Widget> _drawerPages = <Widget>[
    OverallHealthPage(),
    ActivitiesPage(),
    TipsHealthPage(),
  ];

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

  void _onDrawerItemTapped(int index) {
    Navigator.pop(context);
    setState(() {
      _selectedIndex = 3 + index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Container(
        margin: EdgeInsets.fromLTRB(0, 130, 0, 0),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 70),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          bottom: BorderSide(width: 2.0, color: Colors.black),
                        ),
                      ),
                      child: Text(
                        'หน้าหลัก',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.broken_image_outlined),
                title: Text('สรุปภาพรวมสุขภาพ'),
                onTap: () => _onDrawerItemTapped(0),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text('กิจประจำวัน'),
                onTap: () => _onDrawerItemTapped(1),
              ),
              ListTile(
                leading: Icon(Icons.local_library_sharp),
                title: Text('เกร็ดน่ารู้เรื่องสุขภาพ'),
                onTap: () => _onDrawerItemTapped(2),
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
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Text(
                      "สวัสดี, <ชื่อ>",
                      style: TextStyle(color: Colors.black, fontSize: 30),
                    ),
                    Text(
                      "ภาพรวมสุขภาพ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Column(
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
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.personal_injury_rounded),
            label: 'Person',
          ),
        ],
        currentIndex: _selectedIndex >= 3 ? 0 : _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
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

class Person extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is person Page'),
    );
  }
}

class OverallHealthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is Overall Health Page'),
    );
  }
}

class ActivitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is Activities Page'),
    );
  }
}

class TipsHealthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is Tips Health Page'),
    );
  }
}
