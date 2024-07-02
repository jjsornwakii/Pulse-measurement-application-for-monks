import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sato/navigation.dart';

class Pinauthen extends StatefulWidget {
  const Pinauthen({Key? key}) : super(key: key);

  @override
  State<Pinauthen> createState() => _PinauthenState();
}

class _PinauthenState extends State<Pinauthen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 245, 237, 171),
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildPinTextField(),
                buildPinTextField(),
                buildPinTextField(),
                buildPinTextField(),
                buildPinTextField(),
                buildPinTextField(),
              ],
            ),
           Row(
  children: [
    ElevatedButton(
      onPressed: () {
       
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavigationPage()),
        );

        
      },
      child: Text('EIEI'), 
    ),
  ],
)
          ],
        ),
      ),
    );
  }

  Widget buildPinTextField() {
    return SizedBox(
      height: 68,
      width: 64,
      child: TextField(
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold, // Make the text bold
          color: Colors.black, // Set text color
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        
        inputFormatters: [FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(1)],
        obscureText: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white, // Set background color of TextField
          contentPadding: EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Pinauthen(),
  ));
}
