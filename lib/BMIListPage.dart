import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Service/BMIService.dart';
import '../Model/BMIResponse.dart';
import '../Entity/BMI.dart';
import 'package:intl/intl.dart';

class BMIListPage extends StatefulWidget {
  @override
  _BMIListPageState createState() => _BMIListPageState();
}

class _BMIListPageState extends State<BMIListPage> {
  Future<BMIResponse>? _bmiDataFuture;

  @override
  void initState() {
    super.initState();
    _bmiDataFuture = BMIService.getAllBMI();
  }

  Future<void> _refreshData() async {
    setState(() {
      _bmiDataFuture = BMIService.getAllBMI();
    });
  }

  Future<void> _showAddEditBMIDialog([BMI? bmi]) async {
    final weightController = TextEditingController(text: bmi?.weight.toString());
    final heightController = TextEditingController(text: bmi?.height.toString());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(bmi == null ? 'Thêm BMI' : 'Cập nhật BMI'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Cân nặng (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: heightController,
              decoration: InputDecoration(labelText: 'Chiều cao (m)'),
              keyboardType: TextInputType.number,
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
              final weight = double.tryParse(weightController.text) ?? 0;
              final height = double.tryParse(heightController.text) ?? 0;

              if (weight <= 0 || height <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Vui lòng nhập dữ liệu hợp lệ')),
                );
                return;
              }

              bool success;
              if (bmi == null) {
                success = await BMIService.insertBMI(
                  weight,
                  height,
                  "5a873d56-b984-4eb8-b6c6-bad1c0d6066e", // Replace with actual ID
                );
              } else {
                success = await BMIService.updateBMI(bmi.bmiId, weight, height);
              }

              if (success) {
                Navigator.pop(context);
                _refreshData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(bmi == null ? 'Thêm thành công' : 'Cập nhật thành công')),
                );
              }
            },
            child: Text(bmi == null ? 'Thêm' : 'Cập nhật'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BMI bmi) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa BMI này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await BMIService.deleteBMI(bmi.bmiId);
      if (success) {
        _refreshData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa thành công')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Danh sách BMI',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.blue,
            onPressed: () => _showAddEditBMIDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: FutureBuilder<BMIResponse>(
                future: _bmiDataFuture,
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
                    if (response.status) {
                      return response.data.values.isEmpty
                          ? Center(child: Text("Không có dữ liệu BMI"))
                          : ListView.builder(
                        itemCount: response.data.values.length,
                        itemBuilder: (context, index) {
                          final bmi = response.data.values[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: ListTile(
                              title: Text(
                                "BMI: ${bmi.bmiValue.toStringAsFixed(2)}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Ngày: ${bmi.dateCreated}"),
                                  Text("Cân nặng: ${bmi.weight} kg"),
                                  Text("Chiều cao: ${bmi.height} m"),
                                  Text(
                                    "Phân loại: ${bmi.classification}",
                                    style: TextStyle(
                                      color: _getClassificationColor(bmi.classification),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () => _showAddEditBMIDialog(bmi),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () => _confirmDelete(bmi),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text(response.message));
                    }
                  } else {
                    return Center(child: Text("Không có dữ liệu"));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getClassificationColor(String classification) {
    switch (classification.toLowerCase()) {
      case "nhẹ cân":
        return Colors.orange;
      case "bình thường":
        return Colors.green;
      case "thừa cân":
        return Colors.blue;
      case "béo phì":
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
