import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sato/ActivitiesPage.dart';
import 'package:sato/edituserinfo.dart';
import 'package:sato/login.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:sato/navigation.dart';
import 'dart:convert';

import 'package:sato/userinfoPage.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final GetStorage box = GetStorage();
  final server = dotenv.env['server'] ?? '';
  final port = dotenv.env['port'] ?? '';
  final apipath = dotenv.env['apipath'] ?? '';
  late Future<Map<String, dynamic>> _userInfo;

  @override
  void initState() {
    print("/// userPage.dart");
    print('**************************************');
    super.initState();
    _userInfo = fetchUserInfo();
  }

  Future<Map<String, dynamic>> fetchUserInfo() async {
    final url = 'http://$server:$port/$apipath/userinfo.php';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'user_id': box.read('userId')}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user info');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFDC8),
        leading: Padding(
          padding: const EdgeInsets.all(20.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            tooltip: 'Go Back',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NavigationPage()),
              );
            },
          ),
        ),
      ),
      backgroundColor: Color(0xFFFFFDC8),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No user information available'));
          } else {
            final userInfo = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 173, 173, 173)
                              .withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${userInfo['user_fname'] != null ? userInfo['user_fname'] : 'ชื่อ...'}   ${userInfo['user_lname'] != null ? userInfo['user_lname'] : 'สกุล...'}',
                          style: GoogleFonts.kanit(
                              fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // สี background ของ box
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 175, 175, 175)
                              .withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: Text(
                            'ข้อมูลส่วนตัว',
                            style: GoogleFonts.kanit(fontSize: 18),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.orange,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfoApp()),
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: Text('แก้ไขข้อมูลส่วนตัว',
                              style: GoogleFonts.kanit(fontSize: 18)),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.orange,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EdituserinfoPage()),
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: Text('กิจวัตรประจำวัน',
                              style: GoogleFonts.kanit(fontSize: 18)),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.orange,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ActivitiesPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 1,
                    color: const Color.fromARGB(255, 46, 46, 46),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: () {
                            box.erase();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.logout),
                              SizedBox(width: 8),
                              Text(
                                'ออกจากระบบ',
                                style: GoogleFonts.kanit(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

void main() async {
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  runApp(MaterialApp(
    home: UserPage(),
  ));
}
