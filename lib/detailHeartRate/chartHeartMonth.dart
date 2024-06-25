import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

// Define the ChartColumnData class
class ChartColumnData {
  final String monthYear; // month and year
  final double heartRate; // heart rate value

  ChartColumnData(this.monthYear, this.heartRate);
}

class Chartheartmonth extends StatefulWidget {
  const Chartheartmonth({super.key});

  @override
  _ChartheartmonthState createState() => _ChartheartmonthState();
}

class _ChartheartmonthState extends State<Chartheartmonth> {
  List<ChartColumnData> chartData = [];
  double avgMaxValue = 0;
  String statusText = 'ปกติ';
  final String server = dotenv.env['server'] ?? '';
  final String port = dotenv.env['port'] ?? '';
  final String apipath = dotenv.env['apipath'] ?? '';
  final GetStorage box = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    final url = 'http://$server:$port/$apipath/chartHeartMonth.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'user_id': box.read('userId')}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final monthlyStats = data['monthly_stats'] as List<dynamic>?;
        final overallAvg = data['overall_avg'];

        if (monthlyStats != null) {
          setState(() {
            avgMaxValue = double.parse(overallAvg['AVG_heart_rate']);
            statusText = avgMaxValue > 144 ? 'สูงกว่าปกติ' : 'ปกติ';
            chartData = monthlyStats.map((item) {
              String monthYear = item['month_year'];
              double heartRate = double.parse(item['heart_rate']);
              return ChartColumnData(monthYear, heartRate);
            }).toList();
          });
        } else {
          // Handle the case where monthlyStats is null
          throw Exception('No monthly stats data available');
        }
      } else {
        throw Exception('Failed to load chart data: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle any errors that might occur
      print('Error fetching chart data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่มีข้อมูลของวันนี้กรุณาไปวัด')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellow[100],
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFFFB700),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 15),
                              Image.asset(
                                'assets/icon/heartrate.png',
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 15),
                              Text(
                                'อัตราการเต้นของหัวใจ',
                                style: GoogleFonts.kanit(
                                  color: Color.fromARGB(255, 64, 63, 63),
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'เฉลี่ย : $avgMaxValue',
                                style: GoogleFonts.kanit(
                                  color: Color.fromARGB(255, 56, 55, 55),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                ' bpm',
                                style: GoogleFonts.kanit(
                                  color: Color.fromARGB(255, 113, 112, 112),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: avgMaxValue > 144
                                  ? Colors.red[900]
                                  : Colors.green[900],
                              border: Border.all(width: 1),
                            ),
                            child: Text(
                              statusText,
                              style: GoogleFonts.kanit(
                                color: Color.fromARGB(255, 251, 228, 228),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "อัตราการเต้นของหัวใจ (bpm)",
                        style: GoogleFonts.kanit(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 113, 112, 112),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: SfCartesianChart(
                      plotAreaBackgroundColor: Colors.transparent,
                      margin: const EdgeInsets.symmetric(vertical: 32.0),
                      borderColor: Colors.transparent,
                      borderWidth: 0,
                      plotAreaBorderWidth: 0,
                      enableSideBySideSeriesPlacement: false,
                      primaryXAxis: CategoryAxis(
                        axisLine: AxisLine(color: Colors.transparent),
                        isVisible: true,
                        majorGridLines: MajorGridLines(width: 0),
                        majorTickLines: MajorTickLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(
                        isVisible: true,
                        axisLine: AxisLine(color: Colors.transparent),
                        majorGridLines: MajorGridLines(width: 0),
                        majorTickLines: MajorTickLines(width: 0),
                        minimum: 0,
                        maximum: 180,
                        interval: 20,
                      ),
                      series: <CartesianSeries>[
                        ColumnSeries<ChartColumnData, String>(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                          dataSource: chartData,
                          width: 0.5,
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 225, 222, 222),
                              Colors.deepPurple.shade300,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.center,
                          ),
                          xValueMapper: (ChartColumnData data, _) =>
                              data.monthYear,
                          yValueMapper: (ChartColumnData data, _) =>
                              data.heartRate,
                          ////////////////////// แสดงค่า บนกราฟ
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                          ///////////////////////
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "สรุประดับอัตราการเต้นของหัวใจในวันนี้",
                        style: GoogleFonts.kanit(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 113, 112, 112),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
