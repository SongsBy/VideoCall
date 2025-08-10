import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  init() async {
    final resp = await [Permission.camera, Permission.microphone].request();
    final cameraPermission = resp[Permission.camera];
    final microphonePermission = resp[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted ||
        microphonePermission != PermissionStatus.granted) {
      throw '카메라 또는 마이크 권한을 허용해 주세요';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live')),
      body: Stack(
        children: [
          Container(color: Colors.red),
          Container(width: 120, height: 160, color: Colors.blue),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(onPressed: () {}, child: Text('나가기')),
          ),
        ],
      ),
    );
  }
}
