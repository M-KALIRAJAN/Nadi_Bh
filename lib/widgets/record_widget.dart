import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordWidget extends StatefulWidget {
  final Function(File?)? onRecordComplete;

  const RecordWidget({super.key, this.onRecordComplete});

  @override
  State<RecordWidget> createState() => _RecordWidgetState();
}

class _RecordWidgetState extends State<RecordWidget> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isRecording = false;
  bool isPlaying = false;
  String? recordedFilePath;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerComplete.listen((event) {
      if (!mounted) return;
      setState(() => isPlaying = false);
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        setState(() => isPlaying = false);
      }
    });
  }

  Future<bool> requestMicPermission() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) return true;
    final result = await Permission.microphone.request();
    return result.isGranted;
  }

  Future<void> startRecording() async {
    final hasPermission = await requestMicPermission();
    if (!hasPermission) return;

    final dir = await getApplicationDocumentsDirectory();
    final path =
        '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _audioRecorder.start(
      RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: path,
    );

    setState(() {
      isRecording = true;
      recordedFilePath = path;
    });
  }

  Future<void> stopRecording() async {
    final path = await _audioRecorder.stop();
    setState(() {
      isRecording = false;
      recordedFilePath = path;
      isPlaying = false;
    });
    if (widget.onRecordComplete != null && path != null) {
      widget.onRecordComplete!(File(path));
    }
  }

  Future<void> playPauseVoice() async {
    if (recordedFilePath == null) return;
    if (isPlaying) {
      await _audioPlayer.pause();
      setState(() => isPlaying = false);
    } else {
      await _audioPlayer.stop(); // reset previous audio
      await _audioPlayer.play(DeviceFileSource(recordedFilePath!));
      setState(() => isPlaying = true);
    }
  }

  Future<void> toggleRecord() async {
    if (isRecording) {
      await stopRecording();
    } else {
      await startRecording();
    }
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: toggleRecord,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: isRecording ? Colors.red : AppColors.button_secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(isRecording ? Icons.stop : Icons.mic, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  isRecording ? "Recording..." : "Record Voice",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (recordedFilePath != null && !isRecording)
          Container(
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: Offset(0, 4), 
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: playPauseVoice,
                  ),
                  const Text("Recorded Voice"),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        recordedFilePath = null;
                        isPlaying = false;
                      });
                      if (widget.onRecordComplete != null) {
                        widget.onRecordComplete!(null);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
