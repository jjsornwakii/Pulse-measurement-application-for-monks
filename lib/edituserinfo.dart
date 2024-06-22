import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
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
  late DateTime birthday = DateTime.now();
  bool _hasChronicDisease = false;
  List<String> _diseaseList = [];
  List<String> _selectedDiseases = [];

  @override
  void initState() {
    super.initState();
    _getUserData();
    _getDisease();
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
      setState(() {
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
        _hasChronicDisease = data['hasChronicDisease'] ?? false;
        _selectedDiseases = data['diseaseDetails'] != null
            ? List<String>.from(data['diseaseDetails'])
            : [];
      });
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
        'hasChronicDisease': _hasChronicDisease,
        'diseaseDetails': _selectedDiseases,
      }),
    );

    if (response.statusCode == 200) {
      print('User data updated successfully');
    } else {
      print(response.body);
    }
  }

  InputDecoration textboxDecoration = InputDecoration(
    hintText: 'กรอกชื่อของคุณ',
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

  TextStyle labelTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ข้อมูลส่วนตัว",
          style: TextStyle(
            color: Color.fromARGB(255, 250, 196, 0),
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 120,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 251, 138),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 251, 138),
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
                            hintText: 'กรอกชื่อของคุณ',
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
                          hintText: 'ที่อยู่/ชื่อวัด',
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
                    const Text("กก."),
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
                          hintText: 'ที่อยู่/ชื่อวัด',
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
                    const Text("ซม."),
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
                                _hasChronicDisease = value!;
                                if (_hasChronicDisease) {
                                  _getDisease();
                                } else {
                                  _selectedDiseases.clear();
                                }
                              });
                            },
                          ),
                          const Text('มี'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Radio(
                            value: false,
                            groupValue: _hasChronicDisease,
                            onChanged: (value) {
                              setState(() {
                                _hasChronicDisease = value!;
                                _selectedDiseases.clear();
                              });
                            },
                          ),
                          const Text('ไม่มี'),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_hasChronicDisease)
                  Column(
                    children: _diseaseList.map((disease) {
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
                      child: const Text('ยกเลิก'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        side: BorderSide(
                            color: const Color.fromARGB(255, 168, 153, 25)),
                        backgroundColor: Colors.white,
                        minimumSize: Size(150, 40),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updateUserData();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserPage()),
                          );
                        }
                      },
                      child: const Text('ยืนยัน'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        side: BorderSide(
                            color: const Color.fromARGB(255, 168, 153, 25)),
                        backgroundColor: Colors.yellow,
                        minimumSize: Size(150, 40),
                      ),
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
