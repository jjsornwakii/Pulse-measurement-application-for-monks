import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:sato/bloodpresure.dart';
import 'package:sato/heartrate.dart';
import 'dart:convert';

import 'package:sato/sugarblood.dart';

class HealthPage extends StatefulWidget {
  @override
  _HealthPage createState() => _HealthPage();
}

class _HealthPage extends State<HealthPage> {
  final GetStorage box = GetStorage();
  final server = dotenv.env['server'] ?? '';
  final port = dotenv.env['port'] ?? '';
  final apipath = dotenv.env['apipath'] ?? '';
  Map<String, dynamic> userData = {};

  @override
  Future<void> _getUserData() async {
    final server = 'your_server_address'; // Replace with your server address
    final port = 'your_server_port'; // Replace with your server port
    final apipath = 'your_api_path'; // Replace with your API endpoint path
    final url = 'http://$server:$port/$apipath/userinfo.php';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'user_id': box.read('userId')}),
    );

    if (response.statusCode == 200) {
      // Successful response, parse JSON
      final data = jsonDecode(response.body);
      setState(() {
        userData = data; // Update userData state with fetched data
      });
    } else {
      // Failed to load user data
      print('Failed to load user data');
    }
  }

  Widget build(BuildContext context) {
    double _sliderValue = 0.5;
    double fontSize = 17;
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 251, 138),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 217, 29),
                minimumSize:
                    Size(screenSize.width * .95, screenSize.height * .15),
                maximumSize:
                    Size(screenSize.width * .95, screenSize.height * .15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HeartRatePage()),
              );
            },
            child: Column(
              children: [
                Text(
                  'แตะเพื่อวัด',
                  style: GoogleFonts.kanit(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 50, 52, 62),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/icon/blood_glucose.png', // ใส่ path ของรูปภาพที่ต้องการใช้
                          height: 50,
                        ),
                        Text(
                          "อัตตราการเต้นของหัวใจ",
                          style: GoogleFonts.kanit(
                            fontSize: fontSize,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 217, 29),
                minimumSize:
                    Size(screenSize.width * .95, screenSize.height * .15),
                maximumSize:
                    Size(screenSize.width * .95, screenSize.height * .15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BloodPressurePage()),
              );
            },
            child: Column(
              children: [
                Text(
                  'แตะเพื่อวัด',
                  style: GoogleFonts.kanit(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 50, 52, 62),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/icon/blood_glucose.png', // ใส่ path ของรูปภาพที่ต้องการใช้
                          height: 50,
                        ),
                        Text(
                          "ความดันโลหิต",
                          style: GoogleFonts.kanit(
                            fontSize: fontSize,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 217, 29),
                minimumSize:
                    Size(screenSize.width * .95, screenSize.height * .15),
                maximumSize:
                    Size(screenSize.width * .95, screenSize.height * .15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SugarbloodPage()),
              );
            },
            child: Column(
              children: [
                Text(
                  'แตะเพื่อวัด',
                  style: GoogleFonts.kanit(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 50, 52, 62),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/icon/blood_glucose.png', // ใส่ path ของรูปภาพที่ต้องการใช้
                          height: 50,
                        ),
                        Text(
                          "ระดับน้ำตาลในเลือด",
                          style: GoogleFonts.kanit(
                            fontSize: fontSize,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
