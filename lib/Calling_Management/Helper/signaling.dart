import 'dart:convert';
import 'package:http/http.dart' as http;

class Signaling {
  final String serverUrl;
  final String clientId;

  Signaling({required this.serverUrl, required this.clientId});

  // Send a signaling message to the server (SDP offer/answer, ICE candidates)
  Future<void> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse('$serverUrl/api/signaling'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'message': message,
        'clientId': clientId,
      }),
    );

    if (response.statusCode == 200) {
      print('Message sent successfully');
    } else {
      throw Exception('Failed to send signaling message');
    }
  }

  // Poll the signaling server for incoming messages
  Future<List<String>> pollMessages() async {
    final response = await http.get(
      Uri.parse('$serverUrl/api/signaling?clientId=$clientId'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return List<String>.from(jsonResponse['messages']);
    } else {
      throw Exception('Failed to poll messages');
    }
  }
}
