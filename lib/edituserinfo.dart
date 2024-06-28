import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:sato/userPage.dart';
import 'package:sato/userinfoPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await GetStorage.init();
  runApp(Edituserinfo());
}

class Edituserinfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Info Form',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: EdituserinfoPage(),
    );
  }
}

class EdituserinfoPage extends StatefulWidget {
  @override
  _EdituserinfoPageState createState() => _EdituserinfoPageState();
}

class _EdituserinfoPageState extends State<EdituserinfoPage> {
  final GetStorage box = GetStorage();
  final String server = dotenv.env['server'] ?? '';
  final String port = dotenv.env['port'] ?? '';
  final String apipath = dotenv.env['apipath'] ?? '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  //final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _wcController = TextEditingController();
  late DateTime birthday = DateTime.now();

  bool _familyhasChronicDisease = true;
  bool _hasChronicDisease = true;
  List<String> _diseaseList = [];
  List<String> _selectedDiseases = [];
  bool readyToFetch = true;
  @override
  void initState() {
    super.initState();
    _getUserData();
    _getDisease();

    _getUserDisease();
  }

  Future<void> _getUserData() async {
    final url = 'http://$server:$port/$apipath/userinfo.php';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'user_id': box.read('userId')}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(
        () {
          _nameController.text = data['user_fname'] ?? "";
          _surnameController.text = data['user_lname'] ?? "";

          if (data['user_birthday'] != null) {
            birthday = DateTime.parse(data['user_birthday']);
            _birthdateController.text = "${birthday?.toLocal()}".split(' ')[0];
          }
          // if (data['user_age'] != null) {
          //   _ageController.text = data['user_age'].toString();
          // }
          if (data['user_address'] != null) {
            _addressController.text = data['user_address'];
          }
          if (data['user_weight'] != null) {
            _weightController.text = data['user_weight'].toString();
          }
          if (data['user_height'] != null) {
            _heightController.text = data['user_height'].toString();
          }
          if (data['wc'] != null) {
            _wcController.text = data['wc'].toString();
          }

          if (data['familyhasChronicDisease'] == "1" ||
              data['familyhasChronicDisease'] == 1) {
            print("******** ${data['familyhasChronicDisease']}");
            _familyhasChronicDisease = true;
          } else {
            print("******** ${data['familyhasChronicDisease']}");
            _familyhasChronicDisease = false;
          }

          if (data['hasChronicDisease'] == "1" ||
              data['hasChronicDisease'] == 1) {
            print(data['hasChronicDisease']);
            _hasChronicDisease = true;
          } else {
            print(data['hasChronicDisease']);
            _hasChronicDisease = false;
          }

          _selectedDiseases = data['diseaseDetails'] != null
              ? List<String>.from(data['diseaseDetails'])
              : [];

          //print(_selectedDiseases);
          // _selectedDiseases = data['diseaseDetails'] != null
          //     ? List<String>.from(data['diseaseDetails'])
          //     : [];
          print("Success to load user data555");
        },
      );
    } else {
      print('Failed to load user data');
    }
  }

  Future<void> _getDisease() async {
    final url = 'http://$server:$port/$apipath/getDisease.php';
    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      setState(() {
        _diseaseList = data.map((d) => d['disease_name'] as String).toList();
      });
    } else {
      print('Failed to load disease data');
    }
  }

  Future<void> _getUserDisease() async {
    final url = 'http://$server:$port/$apipath/getuserDisease.php';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'user_id': box.read('userId')}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      setState(() {
        _selectedDiseases.clear();
        for (var item in data) {
          final diseaseName = item['disease_name'];
          if (_diseaseList.contains(diseaseName)) {
            _selectedDiseases.add(diseaseName);
          }
        }
      });
      print(data);
      print('Success to load user disease data');
    } else {
      print('Failed to load user disease data');
    }
  }

  Future<void> _updateUserData() async {
    final url = 'http://$server:$port/$apipath/update_userinfo.php';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'user_id': box.read('userId'),
        'user_fname': _nameController.text,
        'user_lname': _surnameController.text,
        'user_birthday': _birthdateController.text,
        'user_address': _addressController.text,
        'user_weight': _weightController.text,
        'user_height': _heightController.text,
        'wc': _wcController.text,
        'familyhasChronicDisease': _familyhasChronicDisease,
        'hasChronicDisease': _hasChronicDisease,
        'diseaseDetails': _selectedDiseases,
      }),
    );

    if (response.statusCode == 200) {
      print('User data updated successfully');
    } else {
      print('Failed to update user data: ${response.body}');
    }
  }

  InputDecoration textboxDecoration = InputDecoration(
    hintText: '',
    fillColor: Colors.white,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 5),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      borderRadius: BorderRadius.circular(30.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blue, width: 2.0),
      borderRadius: BorderRadius.circular(30.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 2.0),
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 2.0),
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  TextStyle labelTextStyle = GoogleFonts.kanit(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ข้อมูลส่วนตัว",
          style: GoogleFonts.kanit(
            color: const Color.fromARGB(255, 250, 196, 0),
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 120,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color(0xFFFFFDC8),
      ),
      backgroundColor: const Color(0xFFFFFDC8),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "ชื่อ",
                            style: labelTextStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'กรอกชื่อของคุณ',
                            hintStyle: GoogleFonts.kanit(),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 5, 0, 0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "นามสกุล",
                            style: labelTextStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: _surnameController,
                          decoration: InputDecoration(
                            hintText: 'กรอกนามสกุลของคุณ',
                            hintStyle: GoogleFonts.kanit(),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 5, 0, 0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "ว/ด/ป เกิด",
                            style: labelTextStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: _birthdateController,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.calendar_today),
                            hintText: 'ว/ด/ป เกิด',
                            hintStyle: GoogleFonts.kanit(),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 5, 0, 0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onTap: () async {
                            DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: birthday,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() {
                                birthday = date;

                                _birthdateController.text =
                                    DateFormat('yyyy-MM-dd').format(birthday);
                              });
                            }
                          },
                          readOnly: true,
                        ),
                      ),
                    ),
                  ],
                ),
                // TextFormField(
                //   controller: _ageController,
                //   decoration: InputDecoration(
                //     labelText: 'อายุ',
                //   ),
                //   keyboardType: TextInputType.number,
                // ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "ที่อยู่/ชื่อวัด",
                            style: labelTextStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            hintText: 'ที่อยู่/ชื่อวัด',
                            hintStyle: GoogleFonts.kanit(),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 5, 0, 0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "น้ำหนัก",
                            style: labelTextStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 40,
                      width: 100,
                      child: TextFormField(
                        controller: _weightController,
                        decoration: InputDecoration(
                          hintText: 'กรอกน้ำหนัก',
                          hintStyle: GoogleFonts.kanit(),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 5, 0, 0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Text(
                      "   กก.",
                      style: GoogleFonts.kanit(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "ส่วนสูง",
                            style: labelTextStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 40,
                      width: 100,
                      child: TextFormField(
                        controller: _heightController,
                        decoration: InputDecoration(
                          hintText: 'กรอกส่วนสูง',
                          hintStyle: GoogleFonts.kanit(),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 5, 0, 0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Text(
                      "   ซม.",
                      style: GoogleFonts.kanit(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "เส้นรอบเอว",
                            style: labelTextStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 40,
                      width: 100,
                      child: TextFormField(
                        controller: _wcController,
                        decoration: InputDecoration(
                          hintText: 'กรอกเส้นรอบเอว',
                          hintStyle: GoogleFonts.kanit(),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 5, 0, 0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Text(
                      "   นิ้ว",
                      style: GoogleFonts.kanit(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),

                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              "ประวัติบิดา มารดา หรือพี่",
                              style: labelTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Radio(
                            value: true,
                            groupValue: _familyhasChronicDisease,
                            onChanged: (value) {
                              setState(
                                () {
                                  _familyhasChronicDisease = value!;
                                },
                              );
                            },
                          ),
                          Text(
                            'มี',
                            style: GoogleFonts.kanit(),
                          ),
                          Radio(
                            value: false,
                            groupValue: _familyhasChronicDisease,
                            onChanged: (value) {
                              setState(() {
                                _familyhasChronicDisease = value!;
                              });
                            },
                          ),
                          Text(
                            'ไม่มี',
                            style: GoogleFonts.kanit(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'โรคประจำตัว:',
                      style: labelTextStyle,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Radio(
                            value: true,
                            groupValue: _hasChronicDisease,
                            onChanged: (value) {
                              setState(() {
                                readyToFetch = true;
                                _hasChronicDisease = value!;
                                if (_hasChronicDisease) {
                                  _getDisease();
                                } else {
                                  _selectedDiseases.clear();
                                }
                              });
                            },
                          ),
                          Text(
                            'มี',
                            style: GoogleFonts.kanit(),
                          ),
                          Radio(
                            value: false,
                            groupValue: _hasChronicDisease,
                            onChanged: (value) {
                              setState(() {
                                readyToFetch = false;
                                _hasChronicDisease = value!;
                                _selectedDiseases.clear();
                              });
                            },
                          ),
                          Text(
                            'ไม่มี',
                            style: GoogleFonts.kanit(),
                          ),
                        ],
                      ),
                    ),
                    // Expanded(
                    //   child: Row(
                    //     children: <Widget>[
                    //       Radio(
                    //         value: false,
                    //         groupValue: _hasChronicDisease,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             _hasChronicDisease = value!;
                    //             _selectedDiseases.clear();
                    //           });
                    //         },
                    //       ),
                    //       Text(
                    //         'ไม่มี',
                    //         style: GoogleFonts.kanit(),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                if (_hasChronicDisease)
                  Column(
                    children: _diseaseList.map((disease) {
                      if (readyToFetch) {
                        _getUserDisease();
                        readyToFetch = !readyToFetch;
                      }
                      return CheckboxListTile(
                        title: Text(disease),
                        value: _selectedDiseases.contains(disease),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedDiseases.add(disease);
                            } else {
                              _selectedDiseases.remove(disease);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserPage()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 168, 153, 25)),
                        backgroundColor: Colors.white,
                        minimumSize: const Size(150, 40),
                      ),
                      child: Text('ยกเลิก',
                          style: GoogleFonts.kanit(
                              fontSize: 18, color: Colors.black)),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updateUserData();
                          Navigator.pop(
                            context,
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 168, 153, 25)),
                        backgroundColor: Colors.yellow,
                        minimumSize: const Size(150, 40),
                      ),
                      child: Text('ยืนยัน',
                          style: GoogleFonts.kanit(
                              fontSize: 18, color: Colors.black)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
