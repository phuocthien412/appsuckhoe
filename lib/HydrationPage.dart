import 'package:flutter/material.dart';

class HydrationPage extends StatefulWidget {
  @override
  _HydrationPageState createState() => _HydrationPageState();
}

class _HydrationPageState extends State<HydrationPage> {
  final int goal = 2000; // ml
  int currentIntake = 0;

  void _addWater() {
    // Add 100ml per click
    setState(() {
      currentIntake += 100;
      if (currentIntake > goal) {
        currentIntake = goal; // Cap it at the goal
      }
    });
  }

  void _restart() {
    // Reset the progress
    setState(() {
      currentIntake = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double progress = currentIntake / goal;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Uống Nước',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mục tiêu: 2000ml',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: 120,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                ),
                Container(
                  width: 120,
                  height: 300 * progress,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Đã uống: $currentIntake ml',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: currentIntake < goal
                      ? _addWater
                      : null, // Disable button when goal is reached
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    currentIntake < goal
                        ? 'Thêm 100ml'
                        : 'Bạn đã uống đủ nước!',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _restart, // Reset the progress
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Khởi động lại',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            if (currentIntake >= goal)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Chúc mừng! Bạn đã đạt mục tiêu!',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
