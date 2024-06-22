import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sato/measureBpm.dart';
import 'package:http/http.dart' as http;
import 'package:sato/tipdetailPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String? server = dotenv.env['server'];
  String? port = dotenv.env['port'];
  String? apipath = dotenv.env['apipath'];
  GetStorage box = GetStorage();
  //List<dynamic> imagePaths = ['src/fish.jpg', 'src/fish.jpg'];
  List<dynamic> imagePaths = [];
  List<dynamic> topic = [];

  Map<String, dynamic> newestData = {};
  List<dynamic> tipList = [];

  PageController tipPage = PageController();
  TextEditingController maxPressureVal = TextEditingController();
  TextEditingController minPressureVal = TextEditingController();
  TextEditingController bloodSugarVal = TextEditingController();

  int _currentPage = 0;
  int _advicePage = 0;
  Timer? _timer;

  String user_id = '';
  double _sliderValue = 0.5;

  TextStyle indicatorLine = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
    user_id = box.read("userId");
    _startAutoScroll();

    getTipImg();
    getNewestHealthData();

    print('**************************************');
    print(newestData['age']);
    print(newestData['height']);
    print(newestData['ChronicDisease']);
    print(newestData['blood_sugar']);
    print(newestData['blood_pressure_min']);
    print(newestData['blood_pressure_max']);
    print(newestData['heart_rate']);
    print('**************************************');
  }

  @override
  void dispose() {
    _timer?.cancel();
    tipPage.dispose();
    maxPressureVal.dispose();
    minPressureVal.dispose();
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
    return SingleChildScrollView(
      child: Container(
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    getNewestHealthData();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 191, 0),
                          title: const Text("กรุณากรอกความดันโลหิต"),
                          actions: [
                            Row(
                              children: [
                                const Text(
                                  "SYS",
                                  style: TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: maxPressureVal,
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "DIA",
                                  style: TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    controller: minPressureVal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () => {
                                sentBloodPressure(),
                                getNewestHealthData(),
                                updateRiskMeasure(),
                                Navigator.pop(context),
                              },
                              child: const Text("บันทึก"),
                            ),
                          ],
                        );
                      },
                    );
                  },
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
                          const SizedBox(
                            width: 2,
                          ),
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
                  onPressed: () {
                    getNewestHealthData();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 191, 0),
                          title: const Text("กรุณากรอกระดับน้ำตาลในเลือด"),
                          actions: [
                            const Row(),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "ระดับน้ำตาลในเลือด",
                                  style: TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    controller: bloodSugarVal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () => {
                                sendBloodSugar(),
                                getNewestHealthData(),
                                updateRiskMeasure(),
                                Navigator.pop(context),
                              },
                              child: const Text("บันทึก"),
                            ),
                          ],
                        );
                      },
                    );
                  },
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
                            'assets/icon/heartrate.png', // ใส่ path ของรูปภาพที่ต้องการใช้
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
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color.fromARGB(255, 255, 191, 0),
                      title: const Text("คำแนะนำ"),
                      actions: [],
                    );
                  },
                );
              },
              child: Container(
                width: screenSize.width * .95,
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
                          Text("ระดับความเสี่ยงเป็นโรคเบาหวาน"),
                          Text("กดเพื่อรับคำแนะนำ"),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: screenSize.width * .80,
                            height: 15,
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
                                  left: (_sliderValue / 100) *
                                      ((screenSize.width * .80) -
                                          (24)), // Adjust the left position
                                  top: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 11,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "|",
                                      style: indicatorLine,
                                    ),
                                    Text(
                                      "|",
                                      style: indicatorLine,
                                    ),
                                    Text(
                                      "|",
                                      style: indicatorLine,
                                    ),
                                  ],
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
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: screenSize.width * .95,
              height: screenSize.height * .33,
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "หน้า ${_currentPage + 1} / ${tipList.length}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: PageView.builder(
                          controller: tipPage,
                          scrollDirection: Axis.horizontal,
                          itemCount: tipList.length,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 191, 0),
                                      title:
                                          const Text("กรุณากรอกความดันโลหิต"),
                                      actions: [
                                        Row(
                                          children: [
                                            const Text(
                                              "SYS",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                controller: maxPressureVal,
                                                decoration:
                                                    const InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "DIA",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                                controller: minPressureVal,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ElevatedButton(
                                          onPressed: () => {
                                            sentBloodPressure(),
                                            getNewestHealthData(),
                                            updateRiskMeasure(),
                                            Navigator.pop(context),
                                          },
                                          child: const Text("บันทึก"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        //height: screenSize.height * .17,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              16), // กำหนดความโค้งของขอบ
                                        ),

                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.network(
                                            "http://$server:$port/api_shatu/${tipList[index]['tip_image']}",
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: 2,
                                    // ),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.start,
                                    //   children: [
                                    //     Text(tipList[index]['tip_topic']),
                                    //   ],
                                    // ),
                                  ],
                                ),
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
          ],
        ),
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
        maxPressureVal.text = newestData['blood_pressure_max'].toString();
        minPressureVal.text = newestData['blood_pressure_min'].toString();
        bloodSugarVal.text = newestData['blood_sugar'].toString();
      });
      print('GET NEW DATA');
      print(newestData);
      updateRiskMeasure();
    } else {
      print("get data failed.");
    }
  }

  Future<void> sentBloodPressure() async {
    String url = "http://$server:$port/api_shatu/savebloodPressure.php";

    final response = await http.post(
      Uri.parse(url),
      headers: {"content-type": "application/json"},
      body: json.encode(
        {
          "user_id": user_id,
          "blood_pressure_min": minPressureVal.text,
          "blood_pressure_max": maxPressureVal.text
        },
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        newestData = json.decode(response.body);
      });
      print('Send NEW Blood Pressure DATA');
      print(newestData);
      getNewestHealthData();
    } else {
      print("Send data failed.");
    }
  }

  Future<void> sendBloodSugar() async {
    String url = "http://$server:$port/api_shatu/savebloodSugar.php";

    final response = await http.post(
      Uri.parse(url),
      headers: {"content-type": "application/json"},
      body: json.encode(
        {
          "user_id": user_id,
          "blood_sugar": bloodSugarVal.text,
        },
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        newestData = json.decode(response.body);
      });
      print('Send NEW Blood sugar DATA');
      print(newestData);
    } else {
      print("get data failed.");
    }
  }

  Future<void> getTipImg() async {
    String url = "http://$server:$port/api_shatu/getalltip.php";

    final response = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "Application/Json"},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(responseData["data"]);
      setState(() {
        tipList = responseData["data"];
        // print("************************");
        //print(tipList[0]['tip_image']);
        // imagePaths = List<String>.from(
        //     responseData['data'].map((tip) => tip['tip_image']));

        // topic = List<String>.from(
        //     responseData['data'].map((top) => top['tip_topic']));
      });
      // print("************************");
      // print(imagePaths);
      // print(tipList[1]['tip_id']);
    }
  }

  void updateRiskMeasure() {
    riskMeasure(
      newestData['age'] ?? 0,
      double.parse((newestData['user_height'] ?? '0').toString()),
      double.parse((newestData['user_weight'] ?? '0').toString()),
      int.parse((newestData['ChronicDisease'] ?? '0').toString()),
      int.parse((newestData['blood_sugar'] ?? '0').toString()),
      int.parse((newestData['blood_pressure_min'] ?? '0').toString()),
      int.parse((newestData['blood_pressure_max'] ?? '0').toString()),
      int.parse((newestData['heart_rate'] ?? '0').toString()),
    );
  }

  void riskMeasure(
      int age,
      double height,
      double weight,
      int ChronicDisease,
      int sugar,
      int blood_pressure_min,
      int blood_pressure_max,
      int heart_rate) {
    int score = 0;

    print(age);
    print(height);
    print(weight);
    print(ChronicDisease);
    print(sugar);
    print(blood_pressure_min);
    print(blood_pressure_max);
    print(heart_rate);

    /////////////////
    if (age < 45) {
      score += 0;
    } else if (age < 50) {
      score += 1;
    } else if (age < 60) {
      score += 2;
    } else {
      score += 3;
    }
    /////////////////

    double ibm = (weight) / (height * height);
    if (ibm < 23) {
      score += 0;
    } else if (ibm < 27.49) {
      score += 1;
    } else {
      score += 2;
    }
    ///////////////////
    if (blood_pressure_max < 120) {
      score += 0;
    } else if (blood_pressure_max < 140) {
      score += 1;
    } else {
      score += 3;
    }
    ////////////////
    if (ChronicDisease == 1) {
      score += 2;
    }
    ///////////////
    if (sugar > 100) {
      score += 5;
    }
    setState(() {
      if (score < 3.65) {
        _advicePage = 0;
      } else if (score < 7.727) {
        _advicePage = 1;
      } else if (score < 11.82) {
        _advicePage = 2;
      } else {
        _advicePage = 3;
      }

      _sliderValue = (score / 15) * 100;
    });
  }
}
