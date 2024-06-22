import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({Key? key}) : super(key: key);

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final GetStorage box = GetStorage();

  final List<String> activities = [
    'กินข้าว',
    'เดินเล่น',
    'นอน',
    'ดูหนัง',
    'ฟังเพลง',
    'ดำน้ำ'
  ];

  Map<String, String> riskLevels = {};

  final List<String> riskOptions = ['ไม่เคย', 'บางครั้ง', 'ทำเป็นประจำ'];

  @override
  void initState() {
    super.initState();

    for (var activity in activities) {
      riskLevels[activity] = '';
    }
  }

  void _submitData() {
    print(riskLevels);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.yellow[100],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orange[500], size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          height: 80,
          margin: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'กิจประจำวัน',
                    style: GoogleFonts.kanit(
                      color: Colors.orange[500],
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Icon(Icons.notifications_active_outlined,
                      size: 30, color: Colors.orange),
                ],
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...activities.map((activity) {
                return Card(
                  color: Color.fromARGB(255, 250, 205, 101),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          'assets/background/bkkakak.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              activity,
                              style: GoogleFonts.kanit(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: riskOptions.map((String value) {
                                return Row(
                                  children: [
                                    Radio<String>(
                                      value: value,
                                      groupValue: riskLevels[activity],
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          riskLevels[activity] = newValue!;
                                        });
                                      },
                                    ),
                                    Text(
                                      value,
                                      style: GoogleFonts.kanit(
                                        color: const Color.fromARGB(
                                            255, 20, 19, 18),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: 20), // Add some spacing before the button
              TextButton(
                onPressed: _submitData,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.orange[500],
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                child: Text(
                  "ยืนยันคำตอบ",
                  style: GoogleFonts.kanit(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
