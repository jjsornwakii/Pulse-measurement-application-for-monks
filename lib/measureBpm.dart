import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:http/http.dart' as http;

class MeasureBpmPage extends StatefulWidget {
  @override
  _MeasureBpmPage createState() => _MeasureBpmPage();
}

class _MeasureBpmPage extends State<MeasureBpmPage> {
  String? server = dotenv.env['server'];
  String? port = dotenv.env['port'];
  String? apipath = dotenv.env['apipath'];
  GetStorage box = GetStorage();

  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];
  List<double> bpmList = [];

  //  Widget chart = BPMChart(data);
  Timer? measureTimer;
  Timer? countdownTimer;

  bool isBPMEnabled = false;
  int bpm = 0;
  String user_id = '';

  int measureTime = 15;
  int remainingTime = 0;

  @override
  void initState() {
    user_id = box.read('userId').toString();
    super.initState();
  }

  @override
  void dispose() {
    measureTimer?.cancel();
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 247, 206, 101),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB700),
                ),
                onPressed: () => {
                  Navigator.pop(context),
                },
                child:  Text(
                  'กลับ',
                  style: GoogleFonts.kanit(fontSize: 22, color: Colors.black),
                ),
              ),
            ],
          ),
          !isBPMEnabled
              ? Text(
                  "กรุณานำนิ้วชี้ แตะที่กล้องหลัง",
                  style: GoogleFonts.kanit(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontSize: 27,
                  ),
                )
              : Text(
                  "เหลือเวลาอีก $remainingTime วินาที",
                  style: GoogleFonts.kanit(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontSize: 27,
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  height: 200,
                  width: 200,
                  child: isBPMEnabled
                      ? HeartBPMDialog(
                          cameraWidgetHeight: 200,
                          cameraWidgetWidth: 200,
                          context: context,
                          showTextValues: false,
                          borderRadius: 100,
                          alpha: BorderSide.strokeAlignCenter,
                          onRawData: (value) {
                            setState(() {
                              if (data.length >= 20) data.removeAt(0);
                              data.add(value);

                              if (bpmList.length >= 20) bpmList.removeAt(0);
                              bpmList.add(value.value.toDouble());

                              double sum = bpmList.reduce((a, b) => a + b);
                              print(sum);

                              bpm = (sum / (bpmList.length).toDouble()).toInt();
                            });
                          },
                          onBPM: (value) => setState(
                            () {
                              if (bpmValues.length >= 100) {
                                bpmValues.removeAt(0);
                              }
                              bpmValues.add(
                                SensorValue(
                                  value: value.toDouble(),
                                  time: DateTime.now(),
                                ),
                              );
                            },
                          ),
                        )
                      : const SizedBox(),
                ),
                SizedBox(
                  width: 212,
                  height: 212,
                  child: Visibility(
                    visible: isBPMEnabled,
                    child: const CircularProgressIndicator(
                      color: Color.fromARGB(255, 223, 56, 44),
                      strokeWidth: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: isBPMEnabled && data.isNotEmpty
                ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(), color: Colors.white),
                    height: 150,
                    child: BPMChart(data),
                  )
                : Container(
                    // decoration: BoxDecoration(
                    //     border: Border.all(), color: Colors.white),
                    height: 150,
                  ),
          ),
          // isBPMEnabled && bpmValues.isNotEmpty
          //     ? Container(
          //         decoration: BoxDecoration(border: Border.all()),
          //         constraints: const BoxConstraints.expand(height: 180),
          //         child: BPMChart(bpmValues),
          //       )
          //     : const SizedBox(),
          const SizedBox(
            height: 20,
          ),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
            ),
            child: Text(
              "$bpm bpm.",
              style: GoogleFonts.kanit(
                decoration: TextDecoration.none,
                color: bpm > 120
                    ? Colors.red
                    : bpm > 50
                        ? Colors.green
                        : Colors.orange,
                fontSize: 30,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: !isBPMEnabled
                  ? MaterialStateProperty.all(
                      Color.fromARGB(255, 228, 228, 228))
                  : MaterialStateProperty.all(
                      Color.fromARGB(255, 239, 255, 63)),
              minimumSize: MaterialStateProperty.all(
                const Size(150, 150),
              ),
              iconColor: MaterialStateProperty.all(Colors.red),
            ),
            icon: const Icon(
              Icons.favorite_rounded,
              size: 40,
            ),
            label: Text(
              isBPMEnabled ? "ยกเลิก" : "เริ่มวัด",
              style:  GoogleFonts.kanit(
                fontSize: 35,
              ),
            ),
            onPressed: () => setState(() {
              if (isBPMEnabled) {
                isBPMEnabled = false;
                measureTimer?.cancel();
                saveBPM();
                // dialog.
              } else {
                isBPMEnabled = true;

                remainingTime = measureTime;
                measureTimer?.cancel(); // Cancel any existing timer
                measureTimer = Timer(Duration(seconds: 15), () {
                  setState(
                    () {
                      isBPMEnabled = false;
                      measureTimer?.cancel();
                      saveBPM();
                    },
                  );
                });

                countdownTimer?.cancel();
                countdownTimer =
                    Timer.periodic(const Duration(seconds: 1), (timer) {
                  setState(() {
                    if (remainingTime > 0) {
                      remainingTime--;
                    } else {
                      timer.cancel();
                    }
                  });

                  print(remainingTime);
                });
              }
            }),
          ),
        ],
      ),
    );
  }

  Future<void> saveBPM() async {
    String url = "http://$server:$port/$apipath/savebpm.php";

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          "user_id": user_id,
          "heart_rate": bpm,
        },
      ),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData['message']);
    }
  }
}
