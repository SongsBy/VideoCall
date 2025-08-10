import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:videocall/const/keys.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  RtcEngine? engine;

  int uid = 0;
  int? remoteUid;

  Future<void> init() async {
    final resp = await [Permission.camera, Permission.microphone].request();
    final cameraPermission = resp[Permission.camera];
    final microphonePermission = resp[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted ||
        microphonePermission != PermissionStatus.granted) {
      throw '카메라 또는 마이크 권한을 허용해 주세요';
    }
    if (engine == null) {
      engine = createAgoraRtcEngine();

      await engine!.initialize(RtcEngineContext(appId: appId));

      engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {},///내가 채널을 들어왔을때
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {},///내가 채널을 나갔을때
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) { ///상대가 채널에 들어왔을때
            print('----User Joined----');
            setState(() {
              this.remoteUid = remoteUid;
            });
          },
          onUserOffline:///상대가 나갔을때
              (
                RtcConnection connection,
                int remoteUid,
                UserOfflineReasonType reason,
              ) {
                setState(() {
                  this.remoteUid = remoteUid;
                });
              },
        ),
      );
      await engine!.enableVideo();
      await engine!.startPreview();

      ChannelMediaOptions options = ChannelMediaOptions();

      await engine!.joinChannel(
        token: token,
        channelId: channerName,
        uid: uid,
        options: options,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live')),
      body: FutureBuilder(
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return Stack(
            children: [
              Container(child: renderMainView()),
              Container(
                width: 120,
                height: 160,
                child: AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: engine!,
                    canvas: VideoCanvas(uid: uid),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: ElevatedButton(onPressed: () {
                  engine!.leaveChannel();///채널 나가기
                  engine?.release();///연결 끊기
                  Navigator.of(context).pop();
                }, child: Text('나가기')),
              ),
            ],
          );
        },
      ),
    );
  }

  renderMainView() {
    if (remoteUid == null) {
      return Center(child: CircularProgressIndicator());
    }
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: engine!,
        canvas: VideoCanvas(uid: remoteUid),
        connection: RtcConnection(channelId: channerName),
      ),
    );
  }
}
