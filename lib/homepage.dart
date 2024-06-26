import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
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
  double maxScore = 17;

  TextStyle indicatorLine = GoogleFonts.kanit(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  List<String> adviceTopic = [
    "ความเสี่ยงน้อย",
    "ความเสี่ยงน้อยถึงปานกลาง",
    "ความเสี่ยงปานกลางถึงสูง",
    "ความเสี่ยงสูง",
    "ความเสี่ยงสูงมาก"
  ];
  List<String> adviceText = [
    "• ควรตรวจเช็คสุขภาพประจำทุกปี ลดอาหาร หวาน มัน เค็ม \n\n• ออกกำลังกายสม่ำเสมอ ลด ละ เลิก การสูบบุหรี่ ",
    "• ควรตรวจเช็คสุขภาพประจำทุกปี ลดอาหาร หวาน มัน เค็ม \n\n• การออกกำลังกายสม่ำเสมอ ลด ละ เลิก การสูบบุหรี่ ",
    "• แนะนำให้ตรวจเช็คระดับน้ำตาลในเลือด และความดันโลหิต \n\n• ลดอาหาร หวาน มัน เค็ม \n\n• ออกกำลังกายสม่ำเสมอ \n\n• ลด ละ เลิก การสูบบุหรี่",
    "• แนะนำให้ตรวจเช็คระดับน้ำตาลในเลือดปรับเปลี่ยนพฤติกรรมเพื่อลดปัจจัยเสี่ยงของตัวคุณเอง ได้แก่ \n\n1. ควรควบคุมอาหาร น้ำหนัก ความดันโลหิต \n\n2. ออกกำลังกายสม่ำเสมอ \n\n3. ลด ละ เลิก การสูบบุหรี่ \n\n4.รับคำแนะนำปรึกษากับแพทย์หรือเจ้าหน้าที่สาธารณสุขใกล้บ้าน",
    "• แนะนำให้ตรวจเช็คระดับน้ำตาลในเลือดปรับเปลี่ยนพฤติกรรมเพื่อลดปัจจัยเสี่ยงของตัวคุณเอง ได้แก่ \n\n1. ควรควบคุมอาหาร น้ำหนัก ความดันโลหิต \n\n2. ออกกำลังกายสม่ำเสมอ \n\n3. ลด ละ เลิก การสูบบุหรี่ \n\n4.รับคำแนะนำปรึกษากับแพทย์หรือเจ้าหน้าที่สาธารณสุขใกล้บ้าน"
  ];

  @override
  void initState() {
    print("/// homepage.dart");
    print('**************************************');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
    print(newestData['familyhasChronicDisease']);
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
    double fontSize = 18;
    final screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        width: screenSize.width,
        height: screenSize.height * .8,
        decoration: const BoxDecoration(
          color: Color(0xFFFFFDC8),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB700),
                    minimumSize:
                        Size(screenSize.width * .46, screenSize.height * .15),
                    maximumSize:
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
                          title: Text(
                            "กรุณากรอกความดันโลหิต",
                            style: GoogleFonts.kanit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          actions: [
                            Row(
                              children: [
                                Text(
                                  "SYS",
                                  style: GoogleFonts.kanit(fontSize: 20),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: maxPressureVal,
                                    decoration: const InputDecoration(
                                      hintText: 'กรุณากรอกค่า',
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "mmHg",
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "DIA",
                                  style: GoogleFonts.kanit(fontSize: 20),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: 'กรุณากรอกค่า',
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    controller: minPressureVal,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "mmHg",
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
                            'แตะเพื่อกรอก',
                            style: GoogleFonts.kanit(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 50, 52, 62),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "ความดันโลหิต",
                        style: GoogleFonts.kanit(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB700),
                      minimumSize:
                          Size(screenSize.width * .46, screenSize.height * .15),
                      maximumSize:
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
                          title: Text(
                            "กรุณากรอกระดับน้ำตาลในเลือด",
                            style: GoogleFonts.kanit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          actions: [
                            const Row(),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "ระดับน้ำตาล\nในเลือด",
                                  style: GoogleFonts.kanit(fontSize: 18),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: "กรุณากรอกค่า",
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    controller: bloodSugarVal,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text("mg/dL"),
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
                            'แตะเพื่อกรอก',
                            style: GoogleFonts.kanit(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 50, 52, 62),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "ระดับน้ำตาลในเลือด",
                        style: GoogleFonts.kanit(
                          color: Colors.white,
                          fontSize: fontSize - 2,
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
                backgroundColor: const Color(0xFFFFB700),
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
                    style: GoogleFonts.kanit(
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
                            style: GoogleFonts.kanit(
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
                showAdvice(_advicePage);
              },
              child: Container(
                width: screenSize.width * .95,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB700),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ระดับความเสี่ยงเป็นโรคเบาหวาน",
                            style: GoogleFonts.kanit(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "กดเพื่อรับคำแนะนำ",
                            style: GoogleFonts.kanit(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                                  left: (_sliderValue) *
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
                                    // Text(
                                    //   "|",
                                    //   style: indicatorLine,
                                    // ),
                                    Container(
                                      height: double.maxFinite,
                                      width: 2,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Container(
                                      height: double.maxFinite,
                                      width: 2,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Container(
                                      height: double.maxFinite,
                                      width: 2,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Container(
                                      height: double.maxFinite,
                                      width: 2,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
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
                color: const Color(0xFFFFB700),
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
                        Text(
                          "สาระน่ารู้",
                          style: GoogleFonts.kanit(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "หน้า ${_currentPage + 1} / ${tipList.length}",
                          style: GoogleFonts.kanit(
                              fontSize: 15, fontWeight: FontWeight.bold),
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
                          borderRadius: BorderRadius.circular(10),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                      data: tipList[index],
                                      key: null,
                                    ),
                                  ),
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
                                            "http://$server:$port/$apipath/${tipList[index]['tip_image']}",
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
    String url = "http://$server:$port/$apipath/getHealthData.php";

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
        maxPressureVal.text = newestData['blood_pressure_max'] != null
            ? newestData['blood_pressure_max'].toString()
            : "";
        minPressureVal.text = newestData['blood_pressure_min'] != null
            ? newestData['blood_pressure_min'].toString()
            : "";
        bloodSugarVal.text = newestData['blood_sugar'] != null
            ? newestData['blood_sugar'].toString()
            : "";
      });
      print('GET NEW DATA');
      print(newestData);
      updateRiskMeasure();
    } else {
      print("get data failed.");
    }
  }

  Future<void> sentBloodPressure() async {
    String url = "http://$server:$port/$apipath/savebloodPressure.php";

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
    String url = "http://$server:$port/$apipath/savebloodSugar.php";

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
      getNewestHealthData();
    } else {
      print("get data failed.");
    }
  }

  Future<void> getTipImg() async {
    String url = "http://$server:$port/$apipath/getalltip.php";

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
    print("UPDATE RISK MEASURE");
    riskMeasure(
        newestData['age'] ?? 0,
        double.parse((newestData['user_height'] ?? '0').toString()),
        double.parse((newestData['user_weight'] ?? '0').toString()),
        double.parse((newestData['WC'] ?? '0').toString()) * 2.54,
        int.parse((newestData['ChronicDisease'] ?? '0').toString()),
        int.parse((newestData['blood_sugar'] ?? '0').toString()),
        int.parse((newestData['blood_pressure_min'] ?? '0').toString()),
        int.parse((newestData['blood_pressure_max'] ?? '0').toString()),
        int.parse((newestData['heart_rate'] ?? '0').toString()),
        int.parse((newestData['familyhasChronicDisease'] ?? '0').toString()));
  }

  void riskMeasure(
    int age,
    double height,
    double weight,
    double wc,
    int ChronicDisease,
    int sugar,
    int blood_pressure_min,
    int blood_pressure_max,
    int heart_rate,
    int familyChronicDisease,
  ) {
    setState(() {
      double score = 0;

      print("age = $age");
      print("height = $height");
      print("weight = $weight");
      print("WC = $wc");
      print("Disease $ChronicDisease");
      print("sugar $sugar");
      print("blood_min = $blood_pressure_min");
      print("blood_max = $blood_pressure_max");
      print("H_rate = $heart_rate");
      print("fem  = $familyChronicDisease");

      double w_h = wc / height;
      print("WC/Height = $w_h");
      /////////////////
      if (sugar >= 100) {
        score += 5;

        maxScore = 25;
      } else {
        maxScore = 20;
      }

      if (age < 45) {
        score += 1;
      } else if (age < 50) {
        score += 2;
      } else if (age < 60) {
        score += 3;
      } else {
        score += 4;
      }

      if (w_h < 0.5) {
        score += 0;
      } else if (w_h < 0.6) {
        score += 3;
      } else {
        score += 5;
      }
      /////////////////

      double bmi = (weight) / (height * height * 0.0001);
      print("BMI = $bmi");
      if (bmi < 23) {
        score += 0;
      } else if (bmi < 27.50) {
        score += 1;
      } else {
        score += 3;
      }
      ///////////////////
      if (blood_pressure_max >= 140) {
        score += 4;
      } else if (blood_pressure_max >= 120) {
        score += 2;
      } else {
        score += 0;
      }

      ////////////////
      if (familyChronicDisease == 1) {
        score += 2;
      }

      ////////////////
      if (ChronicDisease == 1) {
        score += 2;
      }
      ///////////////
      // score = ((maxScore / 5) * 2) + 1;
      if (score <= maxScore / 5) {
        _advicePage = 0;
      } else if (score <= (maxScore / 5) * 2) {
        _advicePage = 1;
      } else if (score <= (maxScore / 5) * 3) {
        _advicePage = 2;
      } else if (score <= (maxScore / 5) * 4) {
        _advicePage = 3;
      } else {
        _advicePage = 4;
      }

      print("myscore $score");

      print("คำแนะนำที่ $_advicePage");
      _sliderValue = (score / (maxScore - 0.7));
    });
  }

  void showAdvice(int _index) {
    print("คำแนะนำที่ $_index");
    Color titleColor;
    switch (_index) {
      case 0:
        titleColor = const Color.fromARGB(255, 0, 122, 4);
        break;
      case 1:
        titleColor = const Color.fromARGB(255, 0, 120, 70);
        break;
      case 2:
        titleColor = Color.fromARGB(255, 86, 60, 0);
        break;
      case 3:
        titleColor = const Color.fromARGB(255, 189, 124, 60);
        break;
      case 4:
        titleColor = Colors.red;
        break;
      default:
        titleColor = Colors.black;
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 191, 0),
          title: Text(
            adviceTopic[_index],
            style: GoogleFonts.kanit(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: titleColor,
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                  10,
                ),
                child: Text(
                  "${adviceText[_index]}",
                  style: GoogleFonts.kanit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // actions: [],
        );
      },
    );
  }

  // void _resetScreenOrientation() {
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  // }
}
