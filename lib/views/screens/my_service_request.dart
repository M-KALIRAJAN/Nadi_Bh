import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/services/my_service.dart';
import 'package:nadi_user_app/widgets/ServiceRequestCardShimmer.dart';
import 'package:nadi_user_app/widgets/app_back.dart';
import 'package:nadi_user_app/widgets/my_service_card.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MyServiceRequest extends StatefulWidget {
  const MyServiceRequest({super.key});

  @override
  State<MyServiceRequest> createState() => _MyServiceRequestState();
}

class _MyServiceRequestState extends State<MyServiceRequest> {
  MyService _myService = MyService();
  List<dynamic> MyServices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    myserviceslist();
  }

  String formatDate(String date) {
    if (date.isEmpty) return "";

    try {
      // Backend format
      final inputFormat = DateFormat('yyyy-MM-dd, HH:mm');

      // UI format (SHORT MONTH)
      final outputFormat = DateFormat('d MMM yyyy hh:mm a');

      final DateTime parsedDate = inputFormat.parse(date);

      return outputFormat.format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  Future<void> myserviceslist() async {
    try {
      final response = await _myService.myallservices();
      if (!mounted) return;
      AppLogger.warn("myserviceslist ${jsonEncode(response)}");
     
      setState(() {
        MyServices = response ?? [];
        isLoading = false;
      });

      if (response != null &&
          response.every((e) => e["serviceStatus"] == "completed")) {}
    } catch (e) {
      isLoading = false;
      AppLogger.error("MyServiceerr $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  AppCircleIconButton(icon: Icons.arrow_back,     onPressed: () => context.push(RouteNames.bottomnav),),
                  const Text(
                    "MY Service Request",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: AppFontSizes.large,
                    ),
                  ),
                  const Text(""),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Divider(),

            Expanded(
              child: isLoading
                  ? ListView.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) =>
                          const ServiceRequestCardShimmer(),
                    )
                  : MyServices.isEmpty
                  ?  Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/images/no_request_found.svg",
                            width: 120, // reduce size
                            height: 120,
                            colorFilter: const ColorFilter.mode(
                              Color.fromRGBO(13, 95, 72, 1), // green color
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "No request found",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(13, 95, 72, 1),
                            ),
                          ),
                        
                        ],
                      ),
                    )
                  : AnimationLimiter(
                      child: ListView.builder(
                        itemCount: MyServices.length,
                        itemBuilder: (context, index) {
                          final service = MyServices[index];

                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 700),
                            child: SlideAnimation(
                              verticalOffset: 50, // bottom → top
                              curve: Curves.easeOutCubic,
                              child: FadeInAnimation(
                                child: ServiceRequestCard(
                                  title: service["serviceRequestID"] ?? "",
                                  date: formatDate(service["createdAt"] ?? ""),
                                  description: service["feedback"] ?? "",
                                  serviceStatus: service['serviceStatus'] ?? "",
                                  serviceLogo:
                                      service["serviceId"]['serviceLogo'] ?? "",
                                  onViewDetails: () {
                                    context.push(
                                      RouteNames.serviceRequestDetails,
                                      extra: service,
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
