import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sato/navigation.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? server = dotenv.env['server'];
  String? port = dotenv.env['port'];

  bool _obscureText = true;

  GetStorage box = GetStorage();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser(BuildContext context) async {
    String apiUrl = 'http://$server:$port/api_shatu/login.php';
    print(apiUrl);

    // Prepare data to send
    final Map<String, dynamic> data = {
      'username': usernameController.text,
      'password': passwordController.text,
    };

    // Send POST request to API
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    // Check response status
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Check if login was successful
      if (responseData['message'] == 'success') {
        box.write('userId', responseData['user_id']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavigationPage()),
        );
      } else {
        // Show error message if login failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Show error message if request failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Failed to connect to the server. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              color: Color.fromARGB(255, 247, 206, 101),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/background/BG_Asset.png',
                      height: 350,
                      width: 450,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top:
                        50, // Adjust this value to move the logo image vertically
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        'assets/logo/sathu.png',
                        scale: 0.1,
                        height: 140,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'เข้าสู่ระบบ',
                      style: GoogleFonts.kanit(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ชื่อผู้ใช้',
                              style: GoogleFonts.kanit(
                                fontSize: 23,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                            TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.person, color: Colors.black),
                                hintText: ' | ชื่อผู้ใช้ ',
                                hintStyle: GoogleFonts.kanit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.orange,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 20),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'รหัสผ่าน',
                              style: GoogleFonts.kanit(
                                fontSize: 23,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                            TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.lock, color: Colors.black),
                                hintText: ' | รหัสผ่าน',
                                hintStyle: GoogleFonts.kanit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.orange,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.orange,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  color: Colors.grey,
                                ),
                              ),
                              obscureText: _obscureText,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => loginUser(context),
                      child: Text(
                        'เข้าสู่ระบบ',
                        style: GoogleFonts.kanit(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w400),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ยังไม่มีบัญชีใช่หรือไม่?",
                          style: GoogleFonts.kanit(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.orange,
                          ),
                          onPressed: () {
                            // Add your registration page navigation logic here
                          },
                          child: Text(
                            'สมัครสมาชิก',
                            style: GoogleFonts.kanit(
                                color: Colors.orange, fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() async {
  await dotenv.load(fileName: ".env");

  await GetStorage.init();
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}
