import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({Key? key}) : super(key: key);

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final GetStorage box = GetStorage();

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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Icon(Icons.notifications_active_outlined,
                      size: 30, color: Colors.orange),
                  SizedBox(width: 0)
                ],
              )
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: const ExpansionTileExample()),
          Image.asset(
            'assets/background/bg.png',
            height: 220,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

class ExpansionTileExample extends StatefulWidget {
  const ExpansionTileExample({Key? key}) : super(key: key);

  @override
  State<ExpansionTileExample> createState() => _ExpansionTileExampleState();
}

class _ExpansionTileExampleState extends State<ExpansionTileExample> {
  final server = dotenv.env['server'] ?? '';
  final port = dotenv.env['port'] ?? '';
  final apipath = dotenv.env['apipath'] ?? '';
  final GetStorage box = GetStorage();

  List<Map<String, dynamic>> tasks = [];
  List<bool> isCheckedList = [];
  List<bool> isExpandedList = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    String apiUrl = 'http://$server:$port/$apipath/getTasks.php';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': box.read("userId").toString()}),
    );
    if (response.statusCode == 200) {
      setState(() {
        Iterable taskList = jsonDecode(response.body);
        tasks = taskList.map((task) => task as Map<String, dynamic>).toList();
        isCheckedList =
            tasks.map((task) => task['activity_status'] == 1).toList();
        isExpandedList = List.filled(tasks.length, false);
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> submitData(int taskId, int index) async {
    String apiUrl = 'http://$server:$port/$apipath/updateActivity.php';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'task_id': taskId,
        'user_id': box.read("userId").toString(),
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData.containsKey('message')) {
        print(responseData['message']);
        setState(() {
          isCheckedList[index] = true;
          tasks[index]['activity_status'] = 1;
        });
      } else if (responseData.containsKey('error')) {
        print(responseData['error']);
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: tasks.asMap().entries.map((entry) {
          int index = entry.key;
          var task = entry.value;

          String iconPath = 'assets/icon/default_icon.png';
          if (task['task_img'] != null && task['task_img'].isNotEmpty) {
            iconPath = 'assets/icon/${task['task_img']}';
          }

          return _buildExpansionTile(
            title: task['task_name'],
            iconPath: iconPath,
            isChecked: isCheckedList[index],
            onCheckboxChanged: (bool? newValue) {
              if (newValue == true) {
                int taskId = int.parse(task['task_id']);
                submitData(taskId, index);
              }
            }, // อนุญาตให้มีการโต้ตอบ
            isExpanded: isExpandedList[index],
            onExpansionChanged: (bool expanded) {
              setState(() {
                isExpandedList[index] = expanded;
              });
            },
            children: [
              ListTile(
                title: Text(
                  'ระยะเวลา : ${task['task_duration']} นาที',
                  style: GoogleFonts.kanit(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ElevatedButton(
                  onPressed: task['activity_status'] == 1
                      ? null
                      : () async {
                          int taskId = int.parse(task['task_id']);
                          await submitData(taskId, index);
                        },
                  child: Text(
                    'Submit',
                    style: GoogleFonts.kanit(),
                  ),
                ),
              ),
            ],
            activityStatus: int.parse(task['activity_status'].toString()),
          );
        }).toList(),
      ),
    );
  }

 Widget _buildExpansionTile({
  required String title,
  required String iconPath,
  required bool isChecked,
  required ValueChanged<bool?>? onCheckboxChanged,
  required bool isExpanded,
  required ValueChanged<bool> onExpansionChanged,
  required List<Widget> children,
  required int activityStatus,
}) {
  bool isDisabled = activityStatus == 0;

  return Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.black, width: 1),
      ),
      color: Colors.grey[50],
    ),
    child: ExpansionTile(
      tilePadding: EdgeInsets.all(15),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: Transform.scale(
              scale: 2,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(
                  width: 1.5,
                  color: Colors.orange[700]!,
                ),
                activeColor: Colors.green,
                checkColor: Colors.greenAccent[400],
                value: isChecked,
                onChanged: isDisabled ? null : onCheckboxChanged,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.kanit(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Image.asset(
            iconPath,
            height: 45,
            width: 45,
            fit: BoxFit.cover,
          ),
        ],
      ),
      trailing: Icon(
        isExpanded
            ? Icons.keyboard_arrow_down
            : Icons.arrow_forward_ios_rounded,
        color: Colors.orange,
      ),
      onExpansionChanged: onExpansionChanged,
      children: isDisabled ? [] : children,
    ),
  );
}

}
