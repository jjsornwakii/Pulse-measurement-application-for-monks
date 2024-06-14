import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sato/navigation.dart';
import 'package:http/http.dart' as http;
import 'package:sato/tipdetailPage.dart';

class DetailPage extends StatelessWidget {
  final dynamic data;

  DetailPage({Key? key, this.data}) : super(key: key);

  String? server = dotenv.env['server'];
  String? port = dotenv.env['port'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 234, 234, 234),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  "http://$server:$port/api_shatu/${data['tip_image']}",
                ),
              ),
              Text(data['tip_text']),
            ],
          ),
        ),
      ),
    );
  }
}
