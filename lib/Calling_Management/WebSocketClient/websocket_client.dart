import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient extends StatefulWidget {
  @override
  _WebSocketClientState createState() => _WebSocketClientState();
}

class _WebSocketClientState extends State<WebSocketClient> {
  final WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse('ws://localhost:3000'));
  final TextEditingController _callerController = TextEditingController();
  final TextEditingController _receiverController = TextEditingController();
  List<String> _activeCalls = [];
  String _responseMessage = '';

  void _sendMessage(String messageType, String callerId, String receiverId) {
    final message = json.encode({
      'type': messageType,
      'callerId': callerId,
      'receiverId': receiverId,
    });

    channel.sink.add(message);
  }

  void _endCall(String callId) {
    final message = json.encode({
      'type': 'end-call',
      'callId': callId,
    });

    channel.sink.add(message);
  }

  @override
  void initState() {
    super.initState();

    channel.stream.listen((message) {
      final data = json.decode(message);
      setState(() {
        if (data['type'] == 'call-accepted') {
          _activeCalls.add(data['callId']);
        } else if (data['type'] == 'call-ended') {
          _activeCalls.remove(data['callId']);
        }
        _responseMessage = message;
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebSocket Client')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Response: $_responseMessage'),
            TextField(
              controller: _callerController,
              decoration: InputDecoration(labelText: 'Caller ID'),
            ),
            TextField(
              controller: _receiverController,
              decoration: InputDecoration(labelText: 'Receiver ID'),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _sendMessage(
                      'call',
                      _callerController.text,
                      _receiverController.text,
                    );
                  },
                  child: Text('Start Call'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Assume callId is in the format: caller-receiver
                    String callId =
                        '${_callerController.text}-${_receiverController.text}';
                    _endCall(callId);
                  },
                  child: Text('End Call'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Active Calls:'),
            Expanded(
              child: ListView.builder(
                itemCount: _activeCalls.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_activeCalls[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
