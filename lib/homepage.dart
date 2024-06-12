import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 251, 138),
      ),
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "สวัสดี, <ชื่อ>",
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                  Text(
                    "ภาพรวมสุขภาพ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  CircleAvatar(
                    maxRadius: 25,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),
          /////////////////////
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 183, 0),
                        minimumSize: Size(
                            screenSize.width * .46, screenSize.height * .15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {},
                    child: Text('แตะเพื่อวัด'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 183, 0),
                        minimumSize: Size(
                            screenSize.width * .46, screenSize.height * .15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {},
                    child: Text('แตะเพื่อวัด'),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 183, 0),
                    minimumSize:

                        Size(screenSize.width * .95, screenSize.height * .15),

                        Size(screenSize.width * .46, screenSize.height * .15),

                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {},
                child: Text('แตะเพื่อวัด'),
              ),

              SizedBox(
                height: 10,
              ),
              Container(
                width: screenSize.width * .95,
                height: screenSize.height * .24,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 183, 0),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: screenSize.width * .95,
                height: screenSize.height * .13,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 183, 0),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 183, 0),
                    minimumSize:
                        Size(screenSize.width * .46, screenSize.height * .15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {},
                child: Text('แตะเพื่อวัด'),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 183, 0),
                minimumSize:
                    Size(screenSize.width * .95, screenSize.height * .15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {},
            child: Text('แตะเพื่อวัด'),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: screenSize.width * .95,
            height: screenSize.height * .24,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 183, 0),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: screenSize.width * .95,
            height: screenSize.height * .14,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 183, 0),
              borderRadius: BorderRadius.circular(20),
            ),
          ),

        ],
      ),
    );
  }
}
