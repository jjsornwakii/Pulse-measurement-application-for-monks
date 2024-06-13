import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double _sliderValue = 0.5;
    double fontSize = 17;
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 251, 138),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 217, 29),
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
                        SizedBox(width: 2),
                        Text(
                          'แตะเพื่อวัด',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 50, 52, 62),
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
                    backgroundColor: Color.fromARGB(255, 255, 217, 29),
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
                        SizedBox(width: 2),
                        Text(
                          'แตะเพื่อวัด',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 50, 52, 62),
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
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 217, 29),
                minimumSize:
                    Size(screenSize.width * .95, screenSize.height * .15),
                maximumSize:
                    Size(screenSize.width * .95, screenSize.height * .15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {},
            child: Column(
              children: [
                Text(
                  'แตะเพื่อวัด',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 50, 52, 62),
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
                    SizedBox(
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
          SizedBox(
            height: 10,
          ),
          Container(
            width: screenSize.width * .95,
            height: screenSize.height * .26,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 217, 29),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "สาระน่ารู้",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "หน้า 2 / 3",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(20)),
                  ))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: screenSize.width * .95,
            height: screenSize.height * .11,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 217, 29),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ระดับความเสี่ยง"),
                      Text("รอประเมิน"),
                    ],
                  ),
                  SizedBox(
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
                          gradient: LinearGradient(
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
                                  280, // Adjust the left position
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
}
