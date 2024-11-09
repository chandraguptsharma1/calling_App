import 'package:calling_app/Calling_Management/Home/HomePage.dart';
import 'package:calling_app/Calling_Management/Screens/Calling_Screen.dart';
import 'package:calling_app/Calling_Management/WebSocketClient/websocket_client.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String clientId = Uuid().v4(); // Generates a unique client ID

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
