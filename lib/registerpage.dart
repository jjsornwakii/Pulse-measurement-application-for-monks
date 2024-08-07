import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();
  final TextEditingController PinCheckController = TextEditingController();
  final GetStorage box = GetStorage();
  bool _obscureText = true;

  final server = dotenv.env['server'] ?? '';
  final port = dotenv.env['port'] ?? '';
  final apipath = dotenv.env['apipath'] ?? '';

  @override
  void initState() {
    print("/// registerpage.dart");
    print('**************************************');
    super.initState();
  }

  Future<void> register(BuildContext context) async {
    // Validate form fields
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกชื่อผู้ใช้และรหัสผ่าน'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (passwordController.text != passwordCheckController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('รหัสผ่านไม่ตรงกัน'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // API endpoint for user registration
    String apiUrl = 'http://$server:$port/$apipath/register.php';
    //print(apiUrl);

    // Prepare data to send
    final Map<String, dynamic> data = {
      'username': usernameController.text,
      'password': passwordController.text,
      'pinId': PinCheckController.text
    };

    try {
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

        // Check if registration was successful
        if (responseData['message'] == 'success') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          // Show error message if registration failed
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
          const SnackBar(
            content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อกับ Server'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Show error message if there was an exception
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อกับ Server'),
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
            top: -130,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              color: const Color.fromARGB(255, 247, 206, 101),
              child: Center(
                child: Image.asset(
                  'assets/logo/sathu.png', // Replace with your logo asset
                  height: 210,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'สมัครสมาชิก',
                        style: GoogleFonts.kanit(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ชื่อผู้ใช้',
                            style: GoogleFonts.kanit(fontSize: 16),
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
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'รหัสผ่าน',
                            style: GoogleFonts.kanit(fontSize: 16),
                          ),
                          TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: Colors.black),
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
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ยืนยันรหัสผ่าน',
                            style: GoogleFonts.kanit(fontSize: 16),
                          ),
                          TextField(
                            controller: passwordCheckController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: Colors.black),
                              hintText: ' | ยืนยันรหัสผ่าน',
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
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       'PIN',
                      //       style: GoogleFonts.kanit(fontSize: 16),
                      //     ),
                      //     TextField(
                      //       controller: PinCheckController,
                      //       keyboardType: TextInputType.number,
                      //       maxLength: 6,
                            
                      //       decoration: InputDecoration(
                      //         prefixIcon: Icon(Icons.lock, color: Colors.black),
                      //         hintText: ' | Enter PIN',
                      //         hintStyle: GoogleFonts.kanit(
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.w400,
                      //           color: Colors.grey[600],
                      //         ),
                      //         filled: true,
                      //         fillColor: Colors.grey[200],
                      //         enabledBorder: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(20),
                      //           borderSide: BorderSide(
                      //             color: Colors.transparent,
                      //             width: 1,
                      //           ),
                      //         ),
                      //         focusedBorder: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(20),
                      //           borderSide: BorderSide(
                      //             color: Colors.orange,
                      //             width: 2,
                      //           ),
                      //         ),
                      //         contentPadding: EdgeInsets.symmetric(
                      //             vertical: 16, horizontal: 20),
                      //         suffixIcon: IconButton(
                      //           icon: Icon(
                      //             _obscureText
                      //                 ? Icons.visibility
                      //                 : Icons.visibility_off,
                      //             color: Colors.orange,
                      //           ),
                      //           onPressed: () {
                      //             setState(() {
                      //               _obscureText = !_obscureText;
                      //             });
                      //           },
                      //           color: Colors.grey,
                      //         ),
                      //       ),
                      //       obscureText: _obscureText,
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () => register(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 80, vertical: 12),
                        ),
                        child: Text(
                          'ลงทะเบียน',
                          style: GoogleFonts.kanit(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          'มีบัญชีใช่หรือไม่? เข้าสู่ระบบ',
                          style: GoogleFonts.kanit(
                              color: Colors.orange, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
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
    home: RegisterPage(),
  ));
}
