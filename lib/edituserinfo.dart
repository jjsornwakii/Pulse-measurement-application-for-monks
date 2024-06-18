import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sato/userPage.dart';

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
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  late DateTime birthday;
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
        _nameController.text = data['user_fname'];
        _surnameController.text = data['user_lname'];
        birthday = DateTime.parse(data['user_birthday']);
        _birthdateController.text = "${birthday.toLocal()}".split(' ')[0];
        _ageController.text = data['user_age'].toString();
        _addressController.text = data['user_address'];
        _weightController.text = data['user_weight'].toString();
        _heightController.text = data['user_height'].toString();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 251, 138),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อ',
                ),
              ),
              TextFormField(
                controller: _surnameController,
                decoration: InputDecoration(
                  labelText: 'นามสกุล',
                ),
              ),
              TextFormField(
                controller: _birthdateController,
                decoration: InputDecoration(
                  labelText: 'ว/ด/ป เกิด',
                  suffixIcon: Icon(Icons.calendar_today),
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
                          "${birthday.toLocal()}".split(' ')[0];
                    });
                  }
                },
                readOnly: true,
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'อายุ',
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'ที่อยู่/ชื่อวัด',
                ),
              ),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'น้ำหนัก (กก.)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(
                  labelText: 'ส่วนสูง (ซม.)',
                ),
                keyboardType: TextInputType.number,
              ),
              Row(
                children: <Widget>[
                  Text('โรคประจำตัว:'),
                  SizedBox(width: 10),
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
                        Text('มี'),
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
                        Text('ไม่มี'),
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserPage()),
                      );
                    },
                    child: Text('ยกเลิก'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateUserData();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserPage()),
                        );
                      }
                    },
                    child: Text('ยืนยัน'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
