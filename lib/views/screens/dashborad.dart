import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/core/utils/BlinkingDot.dart';
import 'package:nadi_user_app/core/utils/CommonNetworkImage.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/models/Userdashboard_model.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/providers/fetchpointsnodification.dart';
import 'package:nadi_user_app/providers/serviceProvider.dart';
import 'package:nadi_user_app/services/home_view_service.dart';
import 'package:nadi_user_app/services/ongoing_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/views/screens/AddPointBottomSheet.dart';
import 'package:nadi_user_app/widgets/RecentActivity.dart';
import 'package:nadi_user_app/widgets/app_card.dart';
import 'package:nadi_user_app/widgets/pie_chart.dart';
import 'package:nadi_user_app/widgets/request_cart.dart';

class Dashboard extends ConsumerStatefulWidget {
  final Function(int) onTabChange;
  const Dashboard({super.key, required this.onTabChange});
  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  @override
  bool isLoading = true;
  String userName = "";
  String accountType = "";
  final HomeViewService _homeViewService = HomeViewService();
  final OngoingService _ongoingService = OngoingService();
  DateTime? lastBackPressed;
  UserdashboardModel? dashboard;
  Map<String, dynamic>? _ongoing;
  @override
  void initState() {
    super.initState();
    get_preferencevalue();
    getUserData();
    fetchongoinproces();
    Future.microtask(() {
      ref.read(serviceListProvider.notifier).refresh();
      ref.refresh(fetchpointsnodification);
    });
  }

  Future<void> fetchongoinproces() async {
    try {
      final result = await _ongoingService.fetchongoingprocess();
      setState(() {
        _ongoing = result;
      });
      debugPrint("RESULT: $_ongoing");
    } catch (e) {
      debugPrint("ERROR: $e");
    }
  }

  Future<void> getUserData() async {
    final response = await _homeViewService.userDashboard();
    await AppPreferences.saveusername(response.name);
    await AppPreferences.savePoints(response.points);
    await AppPreferences.saveUserImage(response.image);
    AppLogger.warn("getUserData********* ${response.name}");
    setState(() {
      dashboard = response;
    });
  }

  Future<void> get_preferencevalue() async {
    final type = await AppPreferences.getaccounttype();
    final name = await AppPreferences.getusername();

    if (!mounted) return;

    setState(() {
      accountType = type == "IA" ? "Individual" : "Family";
      userName = name ?? "";
    });
  }

  Widget serviceShimmerItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 8),
            Container(width: 60, height: 8, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget statusItem(Color color, String text) {
    return Row(
      children: [
        Container(
          height: 16,
          width: 16,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: text == "Completed"
                ? AppColors.btn_primery
                : text == "Pending"
                ? Colors.grey
                : AppColors.gold_coin,
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    final services = ref.watch(serviceListProvider);
    final notificationCount = ref.watch(fetchpointsnodification);
    final data = _ongoing?['data'];
    final bool isOngoing = data != null && data['status'] == 'inProgress';
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_img.png"),
            fit: BoxFit.cover, // this makes the image cover the whole screen
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 170,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  // color: AppColors.btn_primery,
                  gradient: LinearGradient(
                    begin: AlignmentGeometry.topCenter,
                    end: AlignmentGeometry.bottomCenter,
                    colors: [
                      Color(0xFF0D5F48), // Top color
                      Color(0xFF75C0AC), // Bottom color
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(51),
                    bottomRight: Radius.circular(51),
                  ),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              dashboard == null
                                  ? const CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.grey,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : (dashboard!.image == null ||
                                        dashboard!.image!.isEmpty)
                                  ? Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.btn_primery,
                                          width: 2,
                                        ),
                                      ),
                                      child: const CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.blue,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl:
                                          "${ImageBaseUrl.baseUrl}/${dashboard!.image}",
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                            radius: 22,
                                            backgroundImage: imageProvider,
                                          ),
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),

                              const SizedBox(width: 12),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Welcome",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    dashboard?.name ?? "Loading...",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            child: InkWell(
                              onTap: () {
                                context.push(RouteNames.pointnodification);
                              },
                              child: Center(
                                child: Stack(
                                  children: [
                                    const Icon(
                                      Icons.notifications_outlined,
                                      color: Colors.white,
                                      size: 27,
                                    ),
                                    notificationCount.when(
                                      loading: () => const SizedBox(),
                                      error: (_, __) => const SizedBox(),
                                      data: (response) {
                                        final count = response.data.length;

                                        if (count == 0) return const SizedBox();

                                        final displayText = count > 99
                                            ? "99+"
                                            : "$count";

                                        return Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            height: 16,
                                            constraints: const BoxConstraints(
                                              minWidth: 16,
                                            ),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                displayText,
                                                style: TextStyle(
                                                  color: AppColors.btn_primery,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 50,
                      width: 315,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            dashboard?.account ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/pointdetails");
                            },
                            child: Container(
                              height: 38,
                              width: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: AppColors.gold_coin,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      "assets/icons/gold_coin.png",
                                      height: 26,
                                      width: 28,
                                    ),
                                    Text(
                                      "${dashboard?.points ?? 0}",
                                      style: TextStyle(
                                        fontSize: AppFontSizes.medium,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              data != null
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // LEFT: Icon
                          Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.red,
                              size: 22,
                            ),
                          ),

                          const SizedBox(width: 12),

                          // CENTER: Technician name + Request ID
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['technicianName'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Request ID: ${data['requestId']}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // RIGHT: Status chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isOngoing
                                  ? Colors.green.shade50
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isOngoing) ...[
                                  const BlinkingDot(),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  isOngoing ? "ONGOING" : "COMPLETED",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isOngoing
                                        ? Colors.green.shade800
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),

              SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 22),
                        child: const Text(
                          "Quick Action",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: AppFontSizes.medium,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 22,
                        width: 66,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          color: AppColors.btn_primery,
                        ),
                        child: TextButton(
                          onPressed: () {
                            context.push(RouteNames.allservice);
                          },
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: const Text(
                            "More..",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSizes.small,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),

                  SizedBox(
                    height: 105,
                    child: services.isEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (_, __) => serviceShimmerItem(),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: services.length,
                            itemBuilder: (context, index) {
                              final service = services[index];
                              final String name = service['name'] ?? '';
                              final String serviceId = service['_id'] ?? "";
                              final String? logo = service['serviceLogo'];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        context.push(
                                          RouteNames.sendservicerequest,
                                          extra: {
                                            'title': name,
                                            "imagePath":
                                                "${ImageBaseUrl.baseUrl}/${service['serviceImage']}",
                                            'serviceId': serviceId,
                                          },
                                        );
                                      },
                                      child: AppCard(
                                        width: 70,
                                        height: 70,
                                        child: CommonNetworkImage(
                                          imageUrl:
                                              "${ImageBaseUrl.baseUrl}/$logo",
                                          size: 30,
                                        ),
                                        // logo != null
                                        //     ? SvgPicture.network(
                                        //         "${ImageBaseUrl.baseUrl}/$logo",
                                        //         fit: BoxFit.contain,
                                        //         placeholderBuilder: (context) =>
                                        //             const Icon(
                                        //               Icons.image,
                                        //               size: 30,
                                        //             ),
                                        //       )
                                        //     : const Icon(
                                        //         Icons.miscellaneous_services,
                                        //       ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RequestCart(
                          title: "Create Request ",

                          color: AppColors.btn_primery,
                          image: Image.asset("assets/icons/add.png"),
                          onTap: () {
                            context.push(RouteNames.creterequest);
                          },
                        ),

                        RequestCart(
                          title: "Add point",
                          image: Image.asset("assets/icons/gold_coin.png"),
                          color: AppColors.gold_coin,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) =>
                                  const AddPointBottomSheetContent(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 20,
                    ),
                    child: Container(
                      height: 172,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Service Overview",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 27,
                                  width: 90,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      widget.onTabChange(
                                        1,
                                      ); // Switch to service tab
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      backgroundColor: AppColors.btn_primery,
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Center(
                                      child: const Text(
                                        "Details",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DonutChartExample(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Recent Activity",
                            style: TextStyle(
                              fontSize: AppFontSizes.medium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () =>
                                      context.push(RouteNames.viewalllogs),
                                  child: Text(
                                    "View All",
                                    style: TextStyle(
                                      fontSize: AppFontSizes.small,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.borderGrey,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: AppColors.borderGrey,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  RecentActivity(limitLogs: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
