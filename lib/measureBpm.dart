import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
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
  GetStorage box = GetStorage();

  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];

  List<double> bpmList = [];

  //  Widget chart = BPMChart(data);
  Timer? measureTimer;
  bool isBPMEnabled = false;
  int bpm = 0;
  String user_id = '';

  @override
  void initState() {
    user_id = box.read('userId').toString();
    super.initState();
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
                  backgroundColor: Color.fromARGB(255, 255, 217, 29),
                ),
                onPressed: () => {
                  Navigator.pop(context),
                },
                child: Text(
                  'กลับ',
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ),
              ),
            ],
          ),
          const Text(
            "กรุณานำนิ้วชี้ แตะที่กล้อง",
            style: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.black,
              fontSize: 27,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),
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
                          if (data.length >= 100) data.removeAt(0);
                          data.add(value);

                          if (bpmList.length >= 100) bpmList.removeAt(0);
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
          ),
          isBPMEnabled && data.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(border: Border.all()),
                  height: 150,
                  child: BPMChart(data),
                )
              : const SizedBox(
                  height: 150,
                ),
          // isBPMEnabled && bpmValues.isNotEmpty
          //     ? Container(
          //         decoration: BoxDecoration(border: Border.all()),
          //         constraints: const BoxConstraints.expand(height: 180),
          //         child: BPMChart(bpmValues),
          //       )
          //     : const SizedBox(),
          SizedBox(
            height: 20,
          ),

          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Text(
              "$bpm bpm.",
              style: TextStyle(
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
          SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                  Size(150, 150),
                ),
                iconColor: MaterialStateProperty.all(Colors.red)),
            icon: const Icon(
              Icons.favorite_rounded,
              size: 40,
            ),
            label: Text(
              isBPMEnabled ? "ยกเลิก" : "เริ่มวัด",
              style: TextStyle(
                fontSize: 35,
              ),
            ),
            onPressed: () => setState(() {
              if (isBPMEnabled) {
                isBPMEnabled = false;
                saveBPM();
                // dialog.
              } else
                isBPMEnabled = true;
            }),
          ),
        ],
      ),
    );
  }

  Future<void> saveBPM() async {
    String url = "http://$server:$port/api_shatu/savebpm.php";

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
