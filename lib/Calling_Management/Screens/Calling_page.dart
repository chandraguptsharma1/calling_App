import 'package:flutter/material.dart';

class CallingPage extends StatelessWidget {
  const CallingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800], // Background color of the top section
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top section with "Calling..."
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: const Text(
              "Calling......",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Circular avatar with caller's image
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[300],
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 20),

          // Caller ID and caller's name
          const Column(
            children: [
              Text(
                "Caller Id",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "1dgdhd",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Bottom section with end call button
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(bottom: 40),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green, // Color of call button
                  child: IconButton(
                    icon: const Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      // Action for call button
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
