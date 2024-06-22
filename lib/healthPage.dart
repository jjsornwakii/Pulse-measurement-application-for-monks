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
  String statusText = 'ปกติ';

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
      String imagePath, String chart, Widget targetPage) {
    final screenSize = MediaQuery.of(context).size;
    double fontSize = 23;

    int maxval = 127;

    if (title == 'ความดันโลหิต')
      maxval = 129;
    else if (title == 'ระดับน้ำตาลในเลือด')
      maxval = 127;
    else
      maxval = 144;

    Color colorStatus = Colors.black;

    if (int.tryParse(value) != null && int.parse(value) > maxval) {
      colorStatus = Colors.red.shade900;
      statusText = 'สูงกว่าปกติ';
    } else {
      colorStatus = Colors.green.shade900;
      statusText = 'ปกติ';
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 248, 206, 52),
        shadowColor: Color.fromARGB(255, 10, 10, 10),
        elevation: 5,
        maximumSize: Size(screenSize.width * 0.95, screenSize.height * .24),
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
      child: Container(
        margin: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: GoogleFonts.kanit(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 50, 52, 62),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Image.asset(
                  imagePath,
                  height: 55,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '$value ',
                  style: GoogleFonts.kanit(
                    fontSize: 30,
                    color: Color.fromARGB(255, 248, 244, 244),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$unit',
                  style: GoogleFonts.kanit(
                    fontSize: 30,
                    color: Color.fromARGB(255, 83, 83, 83),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: colorStatus),
                  child: Text(
                    statusText,
                    style: GoogleFonts.kanit(
                      color: Color.fromARGB(255, 251, 228, 228),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  child: Image.asset(
                    chart,
                    fit: BoxFit.cover,
                    height: 70,
                  ),
                ),
              ],
            ),
            Text(
              'แตะเพื่อดูรายละเอียดเพิ่มเติม',
              style: GoogleFonts.kanit(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
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
          color: Color.fromARGB(255, 255, 251, 138),
        ),
        child: Column(
          children: [
            SizedBox(height: 15),
            if (userData.isNotEmpty) ...[
              buildInfoCard(
                'ความดันโลหิต',
                '${userData['blood_pressure_max']} / ${userData['blood_pressure_min']}',
                'mmHg',
                'assets/icon/blood_presure.png',
                'assets/decoration/chartpressure.png',
                BloodPressurePage(),
              ),
              SizedBox(height: 10),
              buildInfoCard(
                'ระดับน้ำตาลในเลือด',
                '${userData['blood_sugar']}',
                'mg/dL',
                'assets/icon/blood_glucose.png',
                'assets/decoration/chartsugar.png',
                SugarbloodPage(),
              ),
              SizedBox(height: 10),
              buildInfoCard(
                'อัตราการเต้นของหัวใจ',
                '${userData['heart_rate']}',
                'bpm',
                'assets/icon/heartrate.png',
                'assets/decoration/chartheart.png',
                HeartRatePage(),
              ),
            ] else ...[
              CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
