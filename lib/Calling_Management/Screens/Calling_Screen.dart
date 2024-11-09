import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Helper/signaling.dart';

class CallingScreen extends StatefulWidget {
  final String signalingServerUrl;
  final String clientId;

  const CallingScreen({
    required this.signalingServerUrl,
    required this.clientId,
    Key? key,
    required String roomId,
  }) : super(key: key);

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  bool isCalling = false;
  Signaling? signaling;

  @override
  void initState() {
    super.initState();
    signaling = Signaling(
      serverUrl: widget.signalingServerUrl,
      clientId: widget.clientId,
    );
    _requestPermissions();
  }

  // Request permissions for microphone and camera
  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.camera,
    ].request();

    if (statuses[Permission.microphone] != PermissionStatus.granted ||
        statuses[Permission.camera] != PermissionStatus.granted) {
      throw Exception('Microphone or Camera permission not granted');
    }
  }

  // Create peer connection and media stream
  Future<void> _createPeerConnection() async {
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': true,
    });

    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    });

    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) async {
      if (candidate != null) {
        await signaling?.sendMessage(candidate.toMap().toString());
      }
    };

    _peerConnection?.onAddStream = (MediaStream stream) {
      print('Received remote stream');
    };

    _peerConnection?.addStream(_localStream!);
  }

  // Create and send SDP offer
  Future<void> _startCall() async {
    await _createPeerConnection();
    RTCSessionDescription offer = await _peerConnection!.createOffer({});
    await _peerConnection!.setLocalDescription(offer);

    await signaling?.sendMessage(offer.toMap().toString());

    setState(() {
      isCalling = true;
    });

    // Poll for responses (SDP answer and ICE candidates)
    _pollForMessages();
  }

  // Polling the server for incoming messages (SDP answers and ICE candidates)
  Future<void> _pollForMessages() async {
    while (isCalling) {
      List<String> messages = await signaling?.pollMessages() ?? [];
      for (var message in messages) {
        dynamic parsedMessage = jsonDecode(message);
        if (parsedMessage['type'] == 'answer') {
          RTCSessionDescription answer = RTCSessionDescription(
            parsedMessage['sdp'],
            parsedMessage['type'],
          );
          await _peerConnection?.setRemoteDescription(answer);
        } else if (parsedMessage['candidate'] != null) {
          RTCIceCandidate candidate = RTCIceCandidate(
            parsedMessage['candidate'],
            parsedMessage['sdpMid'],
            parsedMessage['sdpMLineIndex'],
          );
          await _peerConnection?.addCandidate(candidate);
        }
      }
    }
  }

  // End the call and clean up
  Future<void> _endCall() async {
    _localStream?.getTracks().forEach((track) {
      track.stop();
    });

    _peerConnection?.close();
    _peerConnection = null;

    setState(() {
      isCalling = false;
    });
  }

  @override
  void dispose() {
    _localStream?.dispose();
    _peerConnection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isCalling
                ? ElevatedButton(
                    onPressed: _endCall,
                    child: const Text('End Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  )
                : ElevatedButton(
                    onPressed: _startCall,
                    child: const Text('Start Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
