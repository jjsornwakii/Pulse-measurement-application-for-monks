import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sato/userPage.dart';

void main() async {
  await dotenv.load();
  await GetStorage.init();
  runApp(UserInfoApp());
}

class UserInfoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Info Form',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: UserInfoPage(),
    );
  }
}

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final GetStorage box = GetStorage();
  final String server = dotenv.env['server'] ?? '';
  final String port = dotenv.env['port'] ?? '';
  final String apipath = dotenv.env['apipath'] ?? '';
  final _formKey = GlobalKey<FormState>();
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

  @override
  void initState() {
    super.initState();
    _getUserData();
    _getdisease();
  }

  Future<void> _getUserData() async {
    final url = 'http://$server:$port/api_shatu/userinfo.php';
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
        _hasChronicDisease = data['hasChronicDisease'] == "1";
      });
    } else {
      print('Failed to load user data');
    }
  }

  Future<void> _getdisease() async {
    String apiUrl = 'http://$server:$port/$apipath/getUserdisease.php';
    final url = apiUrl;

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'user_id': box.read('userId')}),
    );
    print(apiUrl);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      setState(() {
        _diseaseList = data.map((d) => d['disease_name'] as String).toList();
      });
    } else {
      print('Failed to load disease data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 251, 138),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อ',
                  labelStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                ),
                readOnly: true,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _surnameController,
                decoration: const InputDecoration(
                  labelText: 'นามสกุล',
                  labelStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                ),
                readOnly: true,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _birthdateController,
                decoration: const InputDecoration(
                  labelText: 'ว/ด/ป เกิด',
                  labelStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'อายุ',
                  labelStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  suffixText: 'ปี',
                ),
                keyboardType: TextInputType.number,
                readOnly: true,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'ที่อยู่/ชื่อวัด',
                  labelStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                ),
                readOnly: true,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'น้ำหนัก',
                  labelStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  suffixText: 'กก.',
                ),
                keyboardType: TextInputType.number,
                readOnly: true,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(
                  labelText: 'ส่วนสูง',
                  labelStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  suffixText: 'ซม.',
                ),
                keyboardType: TextInputType.number,
                readOnly: true,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text('โรคประจำตัว:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Text(_hasChronicDisease ? 'มี' : 'ไม่มี',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              if (_hasChronicDisease)
                Column(
                  children: _diseaseList.map((disease) {
                    return ListTile(
                      title: Text(disease, style: TextStyle(fontSize: 16)),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 20),
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
                    child: Text('กลับ', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
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
