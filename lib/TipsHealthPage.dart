import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sato/navigation.dart';
import 'package:http/http.dart' as http;
import 'package:sato/tipdetailPage.dart';

class TipsHealthPage extends StatefulWidget {
  _TipsHealthPage createState() => _TipsHealthPage();
}

class _TipsHealthPage extends State<TipsHealthPage> {
  String? server = dotenv.env['server'];
  String? port = dotenv.env['port'];

  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    print("***************************************");
    print(server);
    print(port);
    getAllTips();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width,
      height: screenSize.height,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 251, 138),
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
                    backgroundColor: Color.fromARGB(255, 255, 217, 29),
                  ),
                  onPressed: () => {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationPage(),
                      ),
                    ),
                  },
                  child: const Text(
                    "กลับ",
                    style: TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 255, 251, 138),
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
                SizedBox(
                  width: 10,
                ),
                Text(
                  "เกร็ดน่ารู้คู่สุขภาพ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Row(
              children: [
                Expanded(
                  child: Text(
                    "การให้ความรู้และคำแนะนำด้านการดูแลสุขภาพ",
                    style: TextStyle(
                      fontSize: 20,
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
                              "http://$server:$port/api_shatu/${data[index]['tip_image']}",
                            ),
                          ),
                          Text(data[index]['tip_text']),
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
    String url = "http://$server:$port/api_shatu/getalltip.php";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        setState(() {
          data = responseData['data'];
          print(data);
        });
      } else {
        print("Get Tip Failed");
      }
    } else {
      print("Server Error");
    }
  }
}
