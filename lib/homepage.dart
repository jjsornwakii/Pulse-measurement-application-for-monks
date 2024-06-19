import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sato/measureBpm.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String? server = dotenv.env['server'];
  String? port = dotenv.env['port'];
  String? apipath = dotenv.env['apipath'];
  GetStorage box = GetStorage();
  List<dynamic> imagePaths = ['src/fish.jpg', 'src/fish.jpg'];

  Map<String, dynamic> newestData = {};

  PageController tipPage = PageController();

  int _currentPage = 0;
  Timer? _timer;

  String user_id = '';
  double _sliderValue = 0.5;

  @override
  void initState() {
    super.initState();
    user_id = box.read("userId");
    _startAutoScroll();
    getNewestHealthData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    tipPage.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 15), (Timer timer) {
      if (_currentPage < imagePaths.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      tipPage.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = 17;
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 251, 138),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 217, 29),
                    minimumSize:
                        Size(screenSize.width * .46, screenSize.height * .15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icon/blood_presure.png', // ใส่ path ของรูปภาพที่ต้องการใช้
                          height: 50,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'แตะเพื่อวัด',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 50, 52, 62),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "ความดันโลหิต",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 217, 29),
                    minimumSize:
                        Size(screenSize.width * .46, screenSize.height * .15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icon/blood_glucose.png', // ใส่ path ของรูปภาพที่ต้องการใช้
                          height: 50,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'แตะเพื่อวัด',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 50, 52, 62),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "ระดับน้ำตาลในเลือด",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 217, 29),
              minimumSize:
                  Size(screenSize.width * .95, screenSize.height * .15),
              maximumSize:
                  Size(screenSize.width * .95, screenSize.height * .15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              gotoMeasureBPM();
            },
            child: Column(
              children: [
                Text(
                  'แตะเพื่อวัด',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 50, 52, 62),
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
                          "ชีพจร",
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Image.asset(
                          'assets/decoration/graph.png',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: screenSize.width * .95,
            height: screenSize.height * .30,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 217, 29),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "สาระน่ารู้",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "หน้า ${_currentPage + 1} / ${imagePaths.length}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: PageView.builder(
                        controller: tipPage,
                        scrollDirection: Axis.horizontal,
                        itemCount: imagePaths.length,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              "http://$server:$port/api_shatu/${imagePaths[index]}",
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: screenSize.width * .95,
            height: screenSize.height * .11,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 217, 29),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ระดับความเสี่ยง"),
                      Text("รอประเมิน"),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: screenSize.width * .80,
                        height: 23,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2),
                          gradient: const LinearGradient(
                            colors: [
                              Colors.green,
                              Colors.yellow,
                              Colors.red,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: _sliderValue *
                                  screenSize.width *
                                  .80, // Adjust the left position
                              top: 0,
                              bottom: 0,
                              child: Container(
                                width: 20,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void gotoMeasureBPM() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MeasureBpmPage()),
    );
  }

  Future<void> getNewestHealthData() async {
    String url = "http://$server:$port/api_shatu/getHealthData.php";

    final response = await http.post(
      Uri.parse(url),
      headers: {"content-type": "application/json"},
      body: json.encode(
        {"user_id": user_id},
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        newestData = json.decode(response.body);
      });

      print(newestData);
    } else {
      print("get data failed.");
    }
  }

  void riskMeasure(int sugar, int blood_pressure_min, int blood_pressure_max,
      int heart_rate) {}
}
