import 'package:appsk2/HydrationPage.dart';
import 'package:flutter/material.dart';
import 'BMIListPage.dart';
import 'HealthRecordPage.dart';

class TabBarPage extends StatefulWidget {
  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'APP QUẢN LÝ SỨC KHOẺ',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                icon: Icon(Icons.bar_chart),
                text: "BMI",
              ),
              Tab(
                icon: Icon(Icons.favorite),
                text: "Health Records",
              ),
              Tab(
                icon: Icon(Icons.local_drink), // Updated icon
                text: "Uống nước",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BMIListPage(), // Page for BMI
            HealthRecordPage(), // Page for Health Records
            HydrationPage(), // Page for Hydration
          ],
        ),
      ),
    );
  }
}
