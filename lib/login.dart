import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sato/navigation.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser(BuildContext context) async {
<<<<<<< Updated upstream
    // API endpoint for user authentication
    final String apiUrl =
        'http://192.168.1.26/Sathu_2/Pulse-measurement-application-for-monks/api/login.php';
=======
    String apiUrl = 'http://$server:$port/$apipath/login.php';
    print(apiUrl);
>>>>>>> Stashed changes

    final Map<String, dynamic> data = {
      'username': usernameController.text,
      'password': passwordController.text,
    };

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
<<<<<<< Updated upstream
        // Navigate to the homepage
        Navigator.pushReplacement(
=======
        box.write('userId', responseData['user_id']);
        Navigator.push(
>>>>>>> Stashed changes
          context,
          MaterialPageRoute(builder: (context) => NavigationPage()),
        );
      } else {
        // Show error message if login failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed. Please check your credentials.'),
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
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.73,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
<<<<<<< Updated upstream
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40),
                  // Text above the username TextField
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ชื่อผู้ใช้',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Text above the password TextField
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'รหัสผ่าน',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.visibility),
                            onPressed: () {
                              // Add functionality to toggle password visibility
                            },
                          ),
                        ),
                        obscureText: true,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => loginUser(context),
                    child: Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
=======
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
                            EdgeInsets.symmetric(horizontal: 90, vertical: 10),
>>>>>>> Stashed changes
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                      textStyle: TextStyle(fontSize: 18),
                    ),
<<<<<<< Updated upstream
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Add navigation to signup page functionality
                    },
                    child: Text(
                      'ยังไม่มีบัญชีใช่หรือไม่? สมัครสมาชิก',
                      style: TextStyle(color: Colors.orange, fontSize: 16),
=======
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
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {},
                          child: Text(
                            'สมัครสมาชิก',
                            style: GoogleFonts.kanit(
                                color: Colors.orange, fontSize: 18),
                          ),
                        )
                      ],
>>>>>>> Stashed changes
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: LoginPage(),
    ));
