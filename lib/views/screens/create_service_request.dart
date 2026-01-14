import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/core/utils/snackbar_helper.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/services/home_view_service.dart';
import 'package:nadi_user_app/services/request_service.dart';
import 'package:nadi_user_app/widgets/app_back.dart';
import 'package:nadi_user_app/widgets/app_date_picker.dart';
import 'package:nadi_user_app/widgets/app_time_picker.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';
import 'package:nadi_user_app/widgets/media_upload_widget.dart';
import 'package:nadi_user_app/widgets/record_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class CreateServiceRequest extends StatefulWidget {
  const CreateServiceRequest({super.key});
  @override
  State<CreateServiceRequest> createState() => _CreateServiceRequestState();
}

class _CreateServiceRequestState extends State<CreateServiceRequest> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> selectedImages = [];
  bool isChecked = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isRecording = false;
  String? recordedFilePath;
  bool isPlaying = false;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  RequestSerivices _requestSerivices = RequestSerivices();
  HomeViewService _homeViewService = HomeViewService();
  final TextEditingController _timeController =
      TextEditingController(); // <-- Add this

  List<Map<String, dynamic>> issueList = [];
  List<Map<String, dynamic>> serviceLst = [];
  bool _isLoading = false;
  String? selectedIssueId;
  String? selectcategoryId;
  StreamSubscription? _playerCompleteSub;
  StreamSubscription? _playerStateSub;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    issuseList();
    serviceList();
  }

  Future<void> issuseList() async {
    final response = await _requestSerivices.IssuseList();
    if (response != null) {
      setState(() {
        issueList = response;
      });
    }
    AppLogger.debug("respose ${jsonEncode(response)}");
  }

  Future<void> serviceList() async {
    final response = await _homeViewService.servicelists();
    if (response != null) {
      setState(() {
        serviceLst = response;
      });
    }
    AppLogger.debug("respose ${jsonEncode(response)}");
  }

  Future<bool> requestMicPermission() async {
    try {
      final status = await Permission.microphone.status;

      if (status.isGranted) {
        return true;
      }

      final result = await Permission.microphone.request();
      return result.isGranted;
    } catch (e) {
      AppLogger.error("Permission error: $e");
      return false;
    }
  }

  // Future<void> startRecording() async {
  //   final hasPermission = await requestMicPermission();

  //   if (!hasPermission) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Microphone permission required")),
  //     );
  //     return;
  //   }

  //   final dir = await getApplicationDocumentsDirectory();
  //   final path =
  //       '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

  //   await _audioRecorder.start(
  //     RecordConfig(
  //       encoder: AudioEncoder.aacLc,
  //       bitRate: 128000,
  //       sampleRate: 44100,
  //     ),
  //     path: path,
  //   );

  //   setState(() {
  //     isRecording = true;
  //     recordedFilePath = path;
  //   });
  // }

  // Future<void> stopRecording() async {
  //   final path = await _audioRecorder.stop();

  //   await _audioPlayer.stop();
  //   setState(() {
  //     isRecording = false;
  //     recordedFilePath = path;
  //     isPlaying = false;
  //   });
  // }

  Future<void> playPauseVoice() async {
    if (recordedFilePath == null) return;

    if (isPlaying) {
      await _audioPlayer.pause();
      setState(() => isPlaying = false);
    } else {
      await _audioPlayer.stop(); //  VERY IMPORTANT (reset previous audio)
      await _audioPlayer.play(DeviceFileSource(recordedFilePath!));
      setState(() => isPlaying = true);
    }
  }

  // Future<void> VoiceRecord() async {
  //   if (isRecording) {
  //     await stopRecording();
  //   } else {
  //     await startRecording();
  //   }
  // }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        selectedImages.add(image);
      });
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _playerCompleteSub?.cancel();
    _playerStateSub?.cancel();

    super.dispose();
  }

  Future<void> SendRequest() async {
    if (selectcategoryId == null || selectedIssueId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select service & issue")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _requestSerivices.createServiceRequestes(
        serviceId: selectcategoryId!,
        issuesId: selectedIssueId!,
        feedback: descriptionController.text,
        scheduleService: _dateController.text,
        immediateAssistance: isChecked,
        images: selectedImages.map((e) => File(e.path)).toList(),
      );

      AppLogger.warn("createServiceRequestes ${jsonEncode(response)}");
final serviceRequestId = response?['data']?['serviceRequestID']?.toString();
  AppLogger.warn("serviceRequestID $serviceRequestId");
      if (!mounted) return;

      setState(() => _isLoading = false);

      if (response != null) {
        final message = response['message'];

        //  SUCCESS
        if (message == "Service created successfully" && serviceRequestId != null) {
          context.push(RouteNames.requestcreatesucess ,extra: serviceRequestId);
        }
        //  ERROR FROM API (ACCOUNT NOT VERIFIED etc.)
        else {
          SnackbarHelper.showError(context, message);
        }
      } else {
        //  NULL RESPONSE
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something went wrong. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      AppLogger.error("SendRequest error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unexpected error occurred"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background_clr,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 17,
                right: 17,
                top: 10,
                bottom: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppCircleIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () {
                      context.pop();
                    },
                  ),
                  const Text(
                    "Create Servie Request",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                  ),
                  const Text(""),
                ],
              ),
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "Servie category",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Select Services*",
                          floatingLabelStyle: const TextStyle(
                            color: AppColors.btn_primery,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.btn_primery,
                              width: 1.5,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: serviceLst.map((isuse) {
                          return DropdownMenuItem<String>(
                            value: isuse["_id"],
                            child: Text(isuse["name"]),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectcategoryId = value;
                          });
                        },
                      ),
                      SizedBox(height: 18),
                      const Text(
                        "Issuse Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: selectedIssueId,
                        decoration: InputDecoration(
                          labelText: "Select Issuse*",
                          floatingLabelStyle: const TextStyle(
                            color: AppColors.btn_primery,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.btn_primery,
                              width: 1.5,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: issueList.map((issue) {
                          return DropdownMenuItem<String>(
                            value: issue['_id'],
                            child: Text(issue['issue']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedIssueId = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: descriptionController,
                        minLines: 5,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: "Describe your issue…",
                          floatingLabelStyle: const TextStyle(
                            color: AppColors.btn_primery,
                          ),
                          alignLabelWithHint: true,
                          contentPadding: EdgeInsets.all(14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.btn_primery,
                              width: 1.5,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 18),
                      const Text(
                        "Perfered Date",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),

                      AppDatePicker(
                        controller: _dateController,
                        label: "Select Date",
                        onDateSelected: (date) {
                          print("Selected Date: $date");
                        },
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        "Preferred Time",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      AppTimePicker(
                        controller: _timeController,
                        label: "Preferred Time",
                        onTimeSelected: (time) {
                          // Do something with the selected time
                          print("User selected: $time");
                        },
                      ),

                      const SizedBox(height: 18),
                      const Text(
                        "Media Upload (optional)",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),

                      MediaUploadWidget(
                        images: selectedImages,
                        onAddTap: () {
                          showImagePickerSheet(context);
                        },
                        onRemoveTap: (index) {
                          setState(() {
                            selectedImages.removeAt(index);
                          });
                        },
                      ),

                      const SizedBox(height: 15),
                      // Container(
                      //   height: 49,
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(12),
                      //     color: Color.fromRGBO(76, 149, 129, 100),
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: GestureDetector(
                      //       onTap: VoiceRecord,
                      //       child: Container(
                      //         height: 49,
                      //         width: double.infinity,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(12),
                      //           color: isRecording
                      //               ? const Color.fromARGB(255, 8, 101, 42)
                      //               : Color.fromRGBO(76, 149, 129, 1),
                      //         ),
                      //         padding: const EdgeInsets.symmetric(
                      //           horizontal: 12,
                      //         ),
                      //         child: Row(
                      //           children: [
                      //             Icon(
                      //               isRecording ? Icons.stop : Icons.mic,
                      //               color: Colors.white,
                      //             ),
                      //             const SizedBox(width: 10),
                      //             Text(
                      //               isRecording
                      //                   ? "Recording... "
                      //                   : "Record Voice",
                      //               style: const TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 16,
                      //               ),
                      //             ),
                      //             const Spacer(),
                      //             if (isRecording)
                      //               const Icon(
                      //                 Icons.circle,
                      //                 color: Colors.white,
                      //                 size: 12,
                      //               ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 15),
                      RecordWidget(
                        onRecordComplete: (file) {
                          setState(() {
                            recordedFilePath = file?.path;
                          });
                        },
                      ),

                      Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            activeColor: AppColors.btn_primery,
                            checkColor: Colors.white,
                            onChanged: (bool? newValue) {
                              setState(() {
                                isChecked = newValue!;
                              });
                            },
                          ),
                          const Text("Need immitated Asstience"),
                        ],
                      ),

                      SizedBox(height: 10),
                      AppButton(
                        text: "Send Request",
                        onPressed: () {
                          SendRequest();
                        },
                        isLoading: _isLoading,
                        color: AppColors.btn_primery,
                        width: double.infinity,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showImagePickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
