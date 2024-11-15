import 'package:flutter/material.dart';

import '../Helper/notification_service.dart';
import '../Screens/Calling_Screen.dart';
import '../Screens/Calling_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  get clientId => null;

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text("WebRTC Call"),
    //     centerTitle: true,
    //   ),
    //   body: Center(
    //     child: ElevatedButton(
    //       onPressed: () {
    //         const signalingServerUrl = 'http://';
    //         const roomId =
    //             '12345'; // Both devices should use the same room ID to connect

    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => CallingScreen(
    //               signalingServerUrl: signalingServerUrl,
    //               clientId: clientId,
    //               roomId: roomId,
    //             ),
    //           ),
    //         );
    //       },
    //       child: const Text('Start Video Call'),
    //     ),
    //   ),
    // );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF0D47A1), // Blue color
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.yellow, // Profile picture background
            child: Icon(Icons.person, color: Colors.black),
          ),
        ),
        title: const Text(
          'Chandra gupt',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Add functionality if needed
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: showIncomingCallNotification,
          // onPressed: () {
          //   // Navigate to CallingScreen when button is clicked
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => CallingPage(),
          //     ),
          //   );
          // },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: const Text(
            'Calling Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
