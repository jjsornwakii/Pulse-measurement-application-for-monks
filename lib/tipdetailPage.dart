import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatefulWidget {
  final dynamic data;

  DetailPage({Key? key, this.data}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? server;
  String? port;
  String? apipath;

  @override
  void initState() {
    super.initState();
    server = dotenv.env['server'];
    port = dotenv.env['port'];
    apipath = dotenv.env['apipath'];
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    print("/// tipdetailPage.dart");
    print('**************************************');
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          Center(
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDC8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10), // เพิ่มระยะห่างระหว่างปุ่ม
                  // FloatingActionButton(
                  //   // เพิ่มปุ่ม FloatingActionButton
                  //   onPressed: () {
                  //     _toggleScreenOrientation(context);
                  //   },
                  //   child: Icon(Icons.screen_rotation), // ใช้ไอคอนแบบหมุนจอ
                  //   backgroundColor: const Color(0xFFFFB700),
                  // ),

                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width: screenSize.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.data['tip_topic'],
                                      style: GoogleFonts.kanit(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFFFB700),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _resetScreenOrientation();
                                        },
                                        child: const Text(
                                          "กลับ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: Color.fromARGB(
                                                255, 255, 254, 225),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              10), // เพิ่มระยะห่างระหว่างปุ่ม
                                      FloatingActionButton(
                                        // เพิ่มปุ่ม FloatingActionButton
                                        onPressed: () {
                                          _toggleScreenOrientation(context);
                                        },
                                        child: Icon(Icons
                                            .screen_rotation), // ใช้ไอคอนแบบหมุนจอ
                                        backgroundColor:
                                            const Color(0xFFFFB700),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: InteractiveViewer(
                                  panEnabled: true,
                                  minScale: 0.5,
                                  maxScale: 4.0,
                                  child: Image.network(
                                    "http://$server:$port/$apipath/${widget.data['tip_image']}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Text(
                                widget.data['tip_text'],
                                style: GoogleFonts.kanit(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),
                  // Column(
                  //   children: [
                  //     ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: const Color(0xFFFFB700),
                  //       ),
                  //       onPressed: () {
                  //         Navigator.pop(context);
                  //         _resetScreenOrientation();
                  //       },
                  //       child: const Text(
                  //         "กลับ",
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 22,
                  //           color: Color.fromARGB(255, 255, 254, 225),
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(width: 10), // เพิ่มระยะห่างระหว่างปุ่ม
                  //     FloatingActionButton(
                  //       // เพิ่มปุ่ม FloatingActionButton
                  //       onPressed: () {
                  //         _toggleScreenOrientation(context);
                  //       },
                  //       child: Icon(Icons.screen_rotation), // ใช้ไอคอนแบบหมุนจอ
                  //       backgroundColor: const Color(0xFFFFB700),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันสำหรับหมุนจอ
  void _toggleScreenOrientation(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  // ฟังก์ชันสำหรับเปลี่ยนให้หน้าจอเป็นแนวตั้ง
  void _resetScreenOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
