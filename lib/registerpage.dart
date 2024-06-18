import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
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
  final GetStorage box = GetStorage();
  bool _obscureText = true;

  final server = dotenv.env['server'] ?? '';
  final port = dotenv.env['port'] ?? '';
  final apipath = dotenv.env['apipath'] ?? '';

  Future<void> register(BuildContext context) async {
    // Validate form fields
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('กรุณากรอกชื่อผู้ใช้และรหัสผ่าน'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (passwordController.text != passwordCheckController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('รหัสผ่านไม่ตรงกัน'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // API endpoint for user registration
    String apiUrl = 'http://$server:$port/$apipath/register.php';
    print(apiUrl);

    // Prepare data to send
    final Map<String, dynamic> data = {
      'username': usernameController.text,
      'password': passwordController.text,
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
          SnackBar(
            content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อกับ Server'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Show error message if there was an exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
              color: Color.fromARGB(255, 247, 206, 101),
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
              decoration: BoxDecoration(
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
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 40),
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
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscureText,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ยืนยันรหัสผ่าน',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextField(
                            controller: passwordCheckController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscureText,
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () => register(context),
                        child: Text(
                          'ลงทะเบียน',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 80, vertical: 12),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 20),
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
                          style: TextStyle(color: Colors.orange, fontSize: 16),
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
