import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final GetStorage box = GetStorage();

  final List<String> activities = [
    'ออกกำลังกาย โดยการบริหารร่างกาย ในท่าต่างๆ ',
    'การใช้เวลาว่าง เช่นกวาดลานวัด'
  ];
  final List<String> eating = [
    'เลือกฉันอาหารที่มีกากใย เช่น ข้าวกล้อง ธัญพืช ผัก',
    'เลือกฉันไขมันที่ดีต่อสุขภาพ เช่น ปลาทู ถั่วลิสง',
    'ฉันเครื่องดื่มที่มีน้ำตาล เช่น เครื่องดื่มชูกำลัง',
    'อาหารรสหวาน เช่น ขนมหวาน น้ำปานะ ที่มีน้ำตาลสูง'
  ];
  final List<String> relax = [
    'ท่านจัดการความเครียดด้วยการสูบบุหรี่',
    'สามารถจัดการกับความเครียดของท่านได้',
    'จัดการความเครียด เช่น นั่งสมาธิ เดินจงกลม และสนทนาธรรมกับญาติ'
  ];

  Map<String, String> riskLevels = {};

  final List<String> riskOptions = [
    'ไม่เคย',
    'ปฏิบัติบางครั้ง',
    'ปฏิบัติประจำ'
  ];
  final Map<String, int> riskScores = {
    'ไม่เคย': 0,
    'ปฏิบัติบางครั้ง': 1,
    'ปฏิบัติประจำ': 2
  };

  @override
  void initState() {
    super.initState();

    for (var activity in activities + eating + relax) {
      riskLevels[activity] = '';
    }
  }

  Future<void> _submitData() async {
    final String server = dotenv.env['server'] ?? '';
    final String port = dotenv.env['port'] ?? '';
    final String apipath = dotenv.env['apipath'] ?? '';
    final String url = 'http://$server:$port/$apipath/behavier.php';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user_id': box.read('userId'),
        'item_1': riskScores[
            riskLevels['ออกกำลังกาย โดยการบริหารร่างกาย ในท่าต่างๆ ']],
        'item_2': riskScores[riskLevels['การใช้เวลาว่าง เช่นกวาดลานวัด']],
        'item_3': riskScores[
            riskLevels['เลือกฉันอาหารที่มีกากใย เช่น ข้าวกล้อง ธัญพืช ผัก']],
        'item_4': riskScores[
            riskLevels['เลือกฉันไขมันที่ดีต่อสุขภาพ เช่น ปลาทู ถั่วลิสง']],
        'item_5': riskScores[
            riskLevels['ฉันเครื่องดื่มที่มีน้ำตาล เช่น เครื่องดื่มชูกำลัง']],
        'item_6': riskScores[
            riskLevels['อาหารรสหวาน เช่น ขนมหวาน น้ำปานะ ที่มีน้ำตาลสูง']],
        'item_7':
            riskScores[riskLevels['ท่านจัดการความเครียดด้วยการสูบบุหรี่']],
        'item_8': riskScores[riskLevels['สามารถจัดการกับความเครียดของท่านได้']],
        'item_9': riskScores[riskLevels[
            'จัดการความเครียด เช่น นั่งสมาธิ เดินจงกลม และสนทนาธรรมกับญาติ']],
      }),
    );

    if (response.statusCode == 200) {
      print('Data sent successfully');
      Navigator.pop(context);
    } else {
      print('Error sending data: ${response.statusCode}');
    }
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
              const Column(
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
              const Column(
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
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('Activities', activities),
              _buildSection('Eating', eating),
              _buildSection('Relax', relax),
              const SizedBox(height: 20), // Add some spacing before the button
              Center(
                child: TextButton(
                  onPressed: _submitData,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.orange[500],
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                  ),
                  child: Text(
                    "บันทึกคำตอบ",
                    style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: GoogleFonts.kanit(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.orange[700],
          ),
        ),
        const SizedBox(height: 10),
        ...items.map((item) {
          return Card(
            color: Color.fromARGB(255, 250, 205, 101),
            shadowColor: Colors.black,
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        item,
                        style: GoogleFonts.kanit(
                          fontSize: 23,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: riskOptions.map((String value) {
                          return Row(
                            children: [
                              Radio<String>(
                                value: value,
                                groupValue: riskLevels[item],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    riskLevels[item] = newValue!;
                                  });
                                },
                              ),
                              Text(
                                value,
                                style: GoogleFonts.kanit(
                                  color: const Color.fromARGB(255, 20, 19, 18),
                                  fontSize: 15,
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
      ],
    );
  }
}
