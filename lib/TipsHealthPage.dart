import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sato/navigation.dart';
import 'package:http/http.dart' as http;
import 'package:sato/tipdetailPage.dart';

class TipsHealthPage extends StatefulWidget {
  _TipsHealthPage createState() => _TipsHealthPage();
}

class _TipsHealthPage extends State<TipsHealthPage> {
  String? server = dotenv.env['server'];
  String? port = dotenv.env['port'];
  String? apipath = dotenv.env['apipath'];
  List<dynamic> data = [];

  @override
  void initState() {
    print("/// TipsHealthPage.dart");
    print('**************************************');
    super.initState();
    getAllTips();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width,
      height: screenSize.height,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFDC8),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFB700),
                  ),
                  onPressed: () => {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationPage(),
                      ),
                    ),
                  },
                  child:  Text(
                    "กลับ",
                    style: GoogleFonts.kanit(
                      fontSize: 22,
                      color: Color(0xFFFFFDC8),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Image.asset(
                  'assets/icon/knowledge.png',
                ),
                const SizedBox(
                  width: 10,
                ),
                 Text(
                  "เกร็ดน่ารู้คู่สุขภาพ",
                  style: GoogleFonts.kanit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none, // Ensure no decoration
                  ),
                ),
              ],
            ),
             Row(
              children: [
                Expanded(
                  child: Text(
                    "การให้ความรู้และคำแนะนำด้านการดูแลสุขภาพ",
                    style: GoogleFonts.kanit(
                      fontSize: 17,
                      color: Colors.black,
                      decoration: TextDecoration.none, // Ensure no decoration
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            data: data[index],
                            key: null,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 234, 234, 234),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              'http://$server:$port/$apipath/${data[index]['tip_image']}',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                data[index]['tip_topic'],
                                style:  GoogleFonts.kanit(
                                  color: Colors.black,
                                  fontSize: 20,
                                  decoration: TextDecoration
                                      .none, // Ensure no decoration
                                   // Handle overflow
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getAllTips() async {
    String url = "http://$server:$port/$apipath/getalltip.php";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        setState(() {
          data = responseData['data'];
          // print(data);
          print("Get Tip Success");
        });
      } else {
        print("Get Tip Failed");
      }
    } else {
      print("Server Error");
    }
  }
}
