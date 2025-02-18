import 'package:appsk2/HealthRecordPage.dart';
import 'package:appsk2/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'BMIListPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}

class SignalRService {
  late HubConnection _connection;

  /// Initialize the SignalR hub connection
  Future<void> connectHub() async {
    _connection = HubConnectionBuilder()
    // sua duong link
        .withUrl('https://largegoldwave19.conveyor.cloud/')
        .build();

    try {
      print("Attempting to connect to SignalR hub...");
      await _connection.start();
      print("Connection established: ${_connection.state}");

      // Listen for messages from the hub
      _connection.on('ReceiveMessage', (arguments) {
        if (arguments != null && arguments.length >= 2) {
          String user = arguments[0] as String;
          String message = arguments[1] as String;
          print("$user: $message");
          // Handle the received message here (e.g., update UI or state)
        }
      });
    } catch (e) {
      print("Error while connecting to SignalR hub: $e");
    }
  }

  /// Disconnect from the SignalR hub
  Future<void> disconnectHub() async {
    try {
      await _connection.stop();
      print("Disconnected from SignalR hub.");
    } catch (e) {
      print("Error while disconnecting: $e");
    }
  }
}
