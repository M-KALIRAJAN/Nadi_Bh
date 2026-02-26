import 'dart:convert';

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/core/utils/snackbar_helper.dart';
import 'package:nadi_user_app/l10n/app_localizations.dart';
import 'package:nadi_user_app/providers/language_provider.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/services/request_service.dart';
import 'package:nadi_user_app/widgets/app_back.dart';
import 'package:nadi_user_app/widgets/app_date_picker.dart';
import 'package:nadi_user_app/widgets/app_time_picker.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';
import 'package:nadi_user_app/widgets/media_upload_widget.dart';
import 'package:nadi_user_app/widgets/record_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class SendServiceRequest extends ConsumerStatefulWidget  {
  final String title;
  final String serviceId;
  final int points;
  final String? imagePath;

  const SendServiceRequest({
    super.key,
    required this.title,
    this.imagePath,
    required this.serviceId,
    required this.points,
  });

  @override
  ConsumerState<SendServiceRequest> createState() => _SendServiceRequestState();
}

class _SendServiceRequestState extends ConsumerState<SendServiceRequest> {
  final TextEditingController _dateController = TextEditingController();
  List<Map<String, dynamic>> issueList = [];
  final ImagePicker _picker = ImagePicker();
  List<XFile> selectedImages = [];
  bool _isLoading = false;
  RequestSerivices _requestSerivices = RequestSerivices();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedIssueId;
  bool isChecked = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isRecording = false;
  File? recordedVoice;
  bool isPlaying = false;
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    issuseList();
  }

  Future<void> playPauseVoice() async {
    if (recordedVoice == null) return;

    if (isPlaying) {
      await _audioPlayer.pause();
      setState(() => isPlaying = false);
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(
        DeviceFileSource(recordedVoice!.path), // ✅ FIX
      );
      setState(() => isPlaying = true);
    }
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

Future<void> issuseList() async {

  final locale = ref.read(languageProvider);
  final lang = locale.languageCode;

  debugPrint("Selected Language = $lang");

  final response = await _requestSerivices.IssuseList(lang);

  if (response != null) {
    setState(() {
      issueList = response;
    });
  }

  AppLogger.debug("response ${jsonEncode(response)}");
}


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

  Future<void> SendRequest() async {
    setState(() {
      _isLoading = true;
    });
    try {
      AppLogger.warn("**************************************88");
      AppLogger.warn("selectcategoryId $widget.serviceId");
      final response = await _requestSerivices.createServiceRequestes(
        serviceId: widget.serviceId,
        issuesId: selectedIssueId!,
        feedback: descriptionController.text,
        scheduleService: _dateController.text,
        immediateAssistance: isChecked,
        images: selectedImages.map((e) => File(e.path)).toList(),
        time: _timeController.text,
        voice: recordedVoice,
      );
      AppLogger.warn("createServiceRequestes ${jsonEncode(response)}");
      final serviceRequestId = response?['data']?['serviceRequestID']
          ?.toString();
      AppLogger.info("serviceRequestId $serviceRequestId");
      if (mounted) setState(() => _isLoading = false);
      if (response != null) {
        final message = response['message'];
        if (message == "Service created successfully" &&
            serviceRequestId != null) {
          context.push(RouteNames.requestcreatesucess, extra: serviceRequestId);
        }
        //  ERROR FROM API (ACCOUNT NOT VERIFIED etc.)
        else {
               setState(() {
      _isLoading = false;
    });
          SnackbarHelper.showError(context, message);
        }
      } else {
          setState(() {
      _isLoading = false;
    });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
      }
    } catch (e) {
           setState(() {
      _isLoading = false;
    });
      AppLogger.error(" $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget imageShimmer() {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    }
 final t = AppLocalizations.of(context)!;
    return Scaffold(
      
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP HEADER
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppCircleIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              const Divider(),

              const SizedBox(height: 15),

              // MAIN CONTENT
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SERVICE IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: widget.imagePath != null
                              ? CachedNetworkImage(
                                  imageUrl: widget.imagePath!,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => imageShimmer(),
                                )
                              : imageShimmer(),
                        ),
                        const SizedBox(height: 25),

                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.app_background_clr.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.app_background_clr.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              /// POINT ICON
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.btn_primery,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.stars_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),

                              const SizedBox(width: 12),

                              /// TEXT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Text(
                                     t.servicePointsRequired,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      widget.points == 0
                                          ? "Service Free"
                                          : "${widget.points} Points",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                         Text(
                          t.issueDetails,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        DropdownButtonFormField<String>(
                          value: selectedIssueId,
                          decoration: InputDecoration(
                            labelText: t.selectIssue,
                            floatingLabelStyle: const TextStyle(
                              color: AppColors.app_background_clr,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.app_background_clr,
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
                        const SizedBox(height: 15),

                        // DESCRIPTION FIELD
                        TextField(
                          controller: descriptionController,
                          minLines: 5,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText:  t.describeIssue,
                            floatingLabelStyle: const TextStyle(
                              color: AppColors.app_background_clr,
                            ),
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.all(14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.app_background_clr,
                                width: 1.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),

                        // const SizedBox(height: 22),
                        // const Text(
                        //   "Perfered Date",
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),

                        // const SizedBox(height: 10),

                        // AppDatePicker(
                        //   controller: _dateController,
                        //   label: "Select Date",
                        //   onDateSelected: (date) {
                        //     print("Selected Date: $date");
                        //   },
                        // ),
                        // const SizedBox(height: 10),
                        // const Text(
                        //   "Perfered Time",
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                        // const SizedBox(height: 10),
                        // AppTimePicker(
                        //   controller: _timeController,
                        //   label: "selected Time",
                        //   onTimeSelected: (time) {
                        //     // Do something with the selected time
                        //     print("User selected********************8: $time");
                        //   },
                        // ),
                        const SizedBox(height: 22),

                         Text(
                          t.mediaUploadOptional,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 3),
                        Text(
                          "${selectedImages.length} / 10 images selected",
                          style: TextStyle(
                            fontSize: 12,
                            color: selectedImages.length == 10
                                ? Colors.red
                                : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 8),
                        // UPLOAD BUTTON
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
                        // Row(
                        //   children: [
                        //     Checkbox(
                        //       value: isChecked,
                        //       activeColor: AppColors.btn_primery,
                        //       checkColor: Colors.white,
                        //       onChanged: (bool? newValue) {
                        //         setState(() {
                        //           isChecked = newValue!;
                        //         });
                        //       },
                        //     ),
                        //     const Text("Need immitated Asstience"),
                        //   ],
                        // ),
                        RecordWidget(
                          onRecordComplete: (file) {
                            recordedVoice = file;
                          },
                        ),

                        const SizedBox(height: 15),
                        // ACTION BUTTONS
                        AppButton(
                          text: "Send Request",
                          onPressed: () {
                            SendRequest();
                          },
                          isLoading: _isLoading,
                          color: AppColors.btn_primery,
                          width: double.infinity,
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                leading: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                title: Text(
                  "Camera",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
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
