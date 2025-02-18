import 'package:flutter/material.dart';
import 'Service/HealthRecordService.dart';
import 'Model/HealthRecordResponse.dart';
import 'package:intl/intl.dart'; // For date formatting

class HealthRecordPage extends StatefulWidget {
  @override
  _HealthRecordPageState createState() => _HealthRecordPageState();
}

class _HealthRecordPageState extends State<HealthRecordPage> {
  Future<HealthRecordResponse>? _healthRecordFuture;

  @override
  void initState() {
    super.initState();
    _healthRecordFuture = HealthRecordService.getAllHealthRecords();
  }

  Future<void> _refreshData() async {
    setState(() {
      _healthRecordFuture = HealthRecordService.getAllHealthRecords();
    });
  }

  Future<void> _showAddHealthRecordDialog() async {
    final bloodPressureController = TextEditingController();
    final dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()), // Automatically set current date and time
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm Hồ Sơ Sức Khỏe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: bloodPressureController,
              decoration: InputDecoration(
                labelText: 'Huyết áp (mmHg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: dateController,
              readOnly: true, // Make the date field read-only
              decoration: InputDecoration(
                labelText: 'Ngày (YYYY-MM-DD HH:mm:ss)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final bloodPressure = double.tryParse(bloodPressureController.text);

              if (bloodPressure == null || bloodPressure <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Vui lòng nhập dữ liệu hợp lệ')),
                );
                return;
              }

              // Call insertHealthRecord API
              final success = await HealthRecordService.insertHealthRecord(
                InsertRecordModel(
                  bloodPressure: bloodPressure,
                ),
              );

              if (success) {
                Navigator.pop(context);
                _refreshData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Thêm thành công!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Thêm thất bại. Vui lòng thử lại.')),
                );
              }
            },
            child: Text('Thêm'),
          ),
        ],
      ),
    );
  }

  String _categorizeBloodPressure(double bloodPressure) {
    if (bloodPressure < 90) {
      return 'Huyết áp thấp';
    } else if (bloodPressure >= 90 && bloodPressure <= 120) {
      return 'Huyết áp bình thường';
    } else if (bloodPressure > 120 && bloodPressure <= 140) {
      return 'Huyết áp cao nhẹ';
    } else {
      return 'Huyết áp cao nghiêm trọng';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Theo Dõi Huyết Áp',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: _showAddHealthRecordDialog,
            child: Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Icon(Icons.add, color: Colors.black),
              decoration: BoxDecoration(
                color: Color(0xffF7F8F8),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<HealthRecordResponse>(
          future: _healthRecordFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Lỗi: ${snapshot.error}"),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshData,
                      child: Text("Thử lại"),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final response = snapshot.data!;
              if (response.status && response.data.values.isNotEmpty) {
                return ListView.builder(
                  itemCount: response.data.values.length,
                  itemBuilder: (context, index) {
                    final record = response.data.values[index];
                    final category = _categorizeBloodPressure(record.bloodPressure);

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text(
                          'Huyết áp: ${record.bloodPressure}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ngày: ${record.dateCreated}',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Loại: $category',
                              style: TextStyle(
                                color: category == 'Huyết áp bình thường'
                                    ? Colors.green
                                    : category == 'Huyết áp thấp'
                                    ? Colors.orange
                                    : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text(response.message),
                );
              }
            }
            return Center(child: Text("Không có dữ liệu"));
          },
        ),
      ),
    );
  }
}
