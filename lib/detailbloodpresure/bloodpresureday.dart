import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

// Define the ChartColumnData class
class ChartColumnData {
  final String x; // time
  final double y; // min
  final double y1; // max

  ChartColumnData(this.x, this.y, this.y1);
}

class Bloodpresureday extends StatefulWidget {
  const Bloodpresureday({super.key});

  @override
  _BloodpresuredayState createState() => _BloodpresuredayState();
}

class _BloodpresuredayState extends State<Bloodpresureday> {
  List<ChartColumnData> chartData = [];
  double maxvalue = 0;
  double avgMinValue = 0;
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
    final url = 'http://$server:$port/$apipath/chartpressureday.php';

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
        final dailyStats = data['daily_stats'] as List<dynamic>?;
        final overallAvg = data['overall_avg'];

        if (dailyStats != null ) {
          setState(() {
            maxvalue = 0;
            avgMinValue = double.parse(overallAvg['avg_blood_pressure_min']);
            avgMaxValue = double.parse(overallAvg['avg_blood_pressure_max']);
            statusText = avgMaxValue > 129 ? 'สูงกว่าปกติ' : 'ปกติ';
            chartData = dailyStats.map((item) {
              String time = item['time'];
              double min = double.parse(item['blood_pressure_min']);
              double max = double.parse(item['blood_pressure_max']);
              if (max > maxvalue) maxvalue = max;
              return ChartColumnData(time, min, max);
            }).toList();
          });
        } else {
          // Handle the case where dailyStats is null
          throw Exception('No daily stats data available');
        }
      } else {
        throw Exception('Failed to load chart data: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle any errors that might occur
      print('Error fetching chart data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'ไม่มีข้อมูลของวันนี้กรุณาไปวัด',
            style: GoogleFonts.kanit(fontSize: 24),
          ),
          duration: Duration(seconds: 3),
        ),
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB700),
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
                              const SizedBox(width: 15),
                              Image.asset(
                                'assets/icon/blood_presure.png',
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 15),
                              Text(
                                'ความดันโลหิต',
                                style: GoogleFonts.kanit(
                                  color: const Color.fromARGB(255, 64, 63, 63),
                                  fontSize: 33,
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
                                  color: const Color.fromARGB(255, 56, 55, 55),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                ' / $avgMinValue mmHg',
                                style: GoogleFonts.kanit(
                                  color:
                                      const Color.fromARGB(255, 113, 112, 112),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: avgMaxValue > 129
                                  ? Colors.red[900]
                                  : Colors.green[900],
                              border: Border.all(width: 1),
                            ),
                            child: Text(
                              statusText,
                              style: GoogleFonts.kanit(
                                color: const Color.fromARGB(255, 251, 228, 228),
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
                        "มิลลิเมตรปรอท (mmHg.)",
                        style: GoogleFonts.kanit(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(255, 113, 112, 112),
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
                      primaryXAxis: const CategoryAxis(
                        axisLine: AxisLine(color: Colors.transparent),
                        isVisible: true,
                        majorGridLines: MajorGridLines(width: 0),
                        majorTickLines: MajorTickLines(width: 0),
                      ),
                      primaryYAxis: const NumericAxis(
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
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                          dataSource: chartData,
                          width: 0.5,
                          color: const Color.fromARGB(255, 240, 238, 238),
                          xValueMapper: (ChartColumnData data, _) => data.x,
                          yValueMapper: (ChartColumnData data, _) => data.y1,
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: GoogleFonts.kanit(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        ColumnSeries<ChartColumnData, String>(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                          dataSource: chartData,
                          width: 0.5,
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 225, 222, 222),
                              Colors.deepPurple.shade300,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.center,
                          ),
                          xValueMapper: (ChartColumnData data, _) => data.x,
                          yValueMapper: (ChartColumnData data, _) => data.y,
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: GoogleFonts.kanit(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "สรุปความดันโลหิตวันนี้",
                        style: GoogleFonts.kanit(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(255, 113, 112, 112),
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
