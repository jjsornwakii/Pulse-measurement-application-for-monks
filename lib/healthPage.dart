import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'bloodpresure.dart';
import 'heartrate.dart';
import 'sugarblood.dart';

class HealthPage extends StatefulWidget {
  @override
  _HealthPageState createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  final GetStorage box = GetStorage();
  final server = dotenv.env['server'] ?? '';
  final port = dotenv.env['port'] ?? '';
  final apipath = dotenv.env['apipath'] ?? '';
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final url = 'http://$server:$port/$apipath/getHealthData.php';
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

  Widget buildInfoCard(String title, String value, String unit,
      String imagePath, Widget targetPage) {
    final screenSize = MediaQuery.of(context).size;
    double fontSize = 17;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 255, 217, 29),
        minimumSize: Size(screenSize.width * .95, screenSize.height * .15),
        maximumSize: Size(screenSize.width * .95, screenSize.height * .15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              height: 50,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 50, 52, 62),
                    ),
                  ),
                  Text(
                    '$value $unit',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'แตะเพื่อดูรายละเอียดเพิ่มเติม',
                    style: TextStyle(
                      fontSize: fontSize * 0.8,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.info, color: Colors.white),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 254, 216),
        ),
        child: Column(
          children: [
            SizedBox(height: 15),
            if (userData.isNotEmpty) ...[
              buildInfoCard(
                'ความดันโลหิต',
                '${userData['blood_pressure_min']} / ${userData['blood_pressure_max']}',
                'mmHg',
                'assets/icon/blood_glucose.png',
                BloodPressurePage(),
              ),
              SizedBox(height: 10),
              buildInfoCard(
                'ระดับน้ำตาลในเลือด',
                '${userData['blood_sugar']}',
                'mg/dL',
                'assets/icon/blood_glucose.png',
                SugarbloodPage(),
              ),
              SizedBox(height: 10),
              buildInfoCard(
                'อัตราการเต้นของหัวใจ',
                '${userData['heart_rate']}',
                'bpm',
                'assets/icon/blood_glucose.png',
                HeartRatePage(),
              ),
            ] else ...[
              CircularProgressIndicator(), // Show a loading indicator while fetching data
            ],
          ],
        ),
      ),
    );
  }
}
