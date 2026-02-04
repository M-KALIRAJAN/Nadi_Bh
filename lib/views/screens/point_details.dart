import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/core/utils/Time_Date.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/providers/AdminQuestioner_Provider.dart';
import 'package:nadi_user_app/providers/family_member_points_list.dart';
import 'package:nadi_user_app/providers/fetchpointsnodification.dart';
import 'package:nadi_user_app/providers/fetchrequestspeoplelist_provider.dart';
import 'package:nadi_user_app/providers/pointshistory_provider.dart';
import 'package:nadi_user_app/providers/userDashboard_provider.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/widgets/app_back.dart';
import 'package:nadi_user_app/widgets/family_points_card.dart';
import 'package:nadi_user_app/widgets/individual_points_card.dart';

class PointDetails extends ConsumerStatefulWidget {
  const PointDetails({super.key});

  @override
  ConsumerState<PointDetails> createState() => _PointDetailsState();
}

class _PointDetailsState extends ConsumerState<PointDetails> {
  String accountType = "";
  String userName = "";
  int points = 0;
  String userImage = "";
  // 🔥 ADD THESE TWO LINES
  bool isExpanded = false;
  final int initialCount = 7;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    Future.microtask(() {
      ref.refresh(pointshistoryprovider);
      ref.refresh(fetchpointsnodification);
      ref.refresh(FamilymemberpointslistProvider);
      ref.refresh(fetchrequestpeoplelistprovider);
      ref.refresh(userdashboardprovider);
      ref.refresh(fetchadminquestionerprovider);
    });
  }

  Future<void> _loadUserData() async {
    final type = await AppPreferences.getaccounttype();
    final name = await AppPreferences.getusername();
    final savedPoints = await AppPreferences.getPoints();
    final image = await AppPreferences.getUserImage();

    if (!mounted) return;

    setState(() {
      accountType = type ?? "IA";
      userName = name ?? "";
      points = savedPoints;
      userImage = image ?? "";
    });
  }

  Future<void> _peopledetails(
    BuildContext context,
    String peopleId,
    String fullName,
    String image,
  ) async {
    final result = await context.push(
      RouteNames.requestPeopleDetails,
      extra: {'peopleId': peopleId, 'fullName': fullName, "image": image},
    );

    if (result == true && mounted) {
      ref.refresh(pointshistoryprovider);
      ref.refresh(userdashboardprovider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pointhistoryAsync = ref.watch(pointshistoryprovider);
    final notificationCount = ref.watch(fetchpointsnodification);
    final familymemberpointlist = ref.watch(FamilymemberpointslistProvider);

    final requestedpointspeoplelist = ref.watch(fetchrequestpeoplelistprovider);
    final dashboardAsync = ref.watch(userdashboardprovider);
    final adminquestionlist = ref.watch(fetchadminquestionerprovider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Background Header
                Container(
                  height: 195,
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 48, left: 20, right: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(213, 155, 8, 1),
                        Color.fromRGBO(246, 201, 86, 1),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(51),
                      bottomRight: Radius.circular(51),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppCircleIconButton(
                        icon: Icons.arrow_back,
                        color: const Color(0xFFF6C956),
                        onPressed: () => Navigator.pop(context),
                      ),

                      const Text(
                        "Points Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),

                      InkWell(
                        onTap: () => context.push(RouteNames.pointnodification),
                        child: Stack(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              child: const Icon(
                                Icons.notifications,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            notificationCount.when(
                              data: (response) {
                                final count = response.data.length;
                                final countText = count > 99 ? "99+" : "$count";
                                return Positioned(
                                  top: 0,
                                  right: 5,
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
                                        countText,
                                        style: TextStyle(
                                          color: AppColors.gold_coin,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              error: (_, _) => const SizedBox(),
                              loading: () => const SizedBox(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Positioned Profile Card
                Positioned(
                  bottom: -40,
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromRGBO(217, 165, 32, 100),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 63,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            color: Color(0xFFD59B08),
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              dashboardAsync.when(
                                loading: () => const SizedBox(),
                                error: (_, __) => const SizedBox(),

                                data: (dashboard) {
                                  final userName = dashboard.name;
                                  final userImage = dashboard.image;

                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      userImage.isEmpty
                                          ? Container(
                                              width: 44,
                                              height: 44,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2,
                                                ),
                                              ),
                                              child: const CircleAvatar(
                                                radius: 22,
                                                backgroundColor: Colors.blue,
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          : Container(
                                              width: 44,
                                              height: 44,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2,
                                                ),
                                              ),
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${ImageBaseUrl.baseUrl}/$userImage",
                                                  fit: BoxFit.cover,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Icon(
                                                            Icons.person,
                                                          ),
                                                ),
                                              ),
                                            ),
                                      const SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Welcome",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            userName.isEmpty
                                                ? "Loading..."
                                                : userName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Container(
                                height: 38,
                                width: 38,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Image.asset("assets/icons/gold.png"),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Your Current Points Balance",
                            style: TextStyle(
                              fontSize: AppFontSizes.small,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        dashboardAsync.when(
                          loading: () => const SizedBox(),
                          error: (_, __) => const SizedBox(),

                          data: (dashboard) {
                            final points = dashboard.points;

                            return Center(
                              child: Text(
                                points.toString(),
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            requestedpointspeoplelist.when(
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
              data: (res) {
                final people = res.data;
                final list = people.length > 7
                    ? people.take(7).toList()
                    : people;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 4),
                      child: const Text(
                        "Points Requests:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 10),

                      itemCount: isExpanded
                          ? people.length
                          : (people.length > initialCount
                                ? initialCount +
                                      1 // +1 for Show More
                                : people.length),

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 7,
                            childAspectRatio: 0.75,
                          ),

                      itemBuilder: (context, index) {
                        /// SHOW MORE TILE
                        if (!isExpanded &&
                            people.length > initialCount &&
                            index == initialCount) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                isExpanded = true;
                              });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.grey,
                                  child: Icon(Icons.keyboard_arrow_down),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Show More",
                                  style: TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          );
                        }
                        final item = people[index];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                _peopledetails(
                                  context,
                                  item.id,
                                  item.basicInfo.fullName,
                                  item.basicInfo.image,
                                );
                              },
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${ImageBaseUrl.baseUrl}/${item.basicInfo.image}",
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.grey,
                                    child: Text(
                                      item.basicInfo.fullName.isNotEmpty
                                          ? item.basicInfo.fullName[0]
                                                .toUpperCase()
                                          : "?",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.basicInfo.fullName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),

            //  adminquestionlist.when(
            //     data: (adminlist) {
            //       final data = adminlist;
            //       if(data.isEmpty){
            //         return const SizedBox();
            //       }
            //       final image = data['image'] ?? "";
            //       final name = data['name'] ?? "Admin";
            //       return Padding(
            //         padding: const EdgeInsets.only(left: 10, bottom: 4),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const SizedBox(height: 10),
            //             const Text(
            //               "Admin Requests:",
            //               style: TextStyle(fontWeight: FontWeight.bold),
            //             ),
            //             const SizedBox(height: 5),
            //             Column(
            //               children: [
            //                 InkWell(
            //                   onTap: () =>
            //                       context.push(RouteNames.adminrequestquestion),
            //                   child: CircleAvatar(
            //                     radius: 25,
            //                     child: image.isEmpty
            //                         ? const Icon(Icons.person)
            //                         : CachedNetworkImage(
            //                             imageUrl:
            //                                 "${ImageAssetUrl.baseUrl}$image",
            //                             errorWidget: (_, __, ___) =>
            //                                 const Icon(Icons.person),
            //                           ),
            //                   ),
            //                 ),
            //                 const SizedBox(height: 3),
            //                 Text(name, style: const TextStyle(fontSize: 12)),
            //               ],
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //     error: (e, _) => Center(child: Text(e.toString())),
            //     loading: () => const SizedBox(),
            //   ),
            adminquestionlist.when(
              data: (adminlist) {
                // adminlist is Map
                final List adminData = adminlist['data'] ?? [];

                // 🔥 If API returns data: []
                if (adminData.isEmpty) {
                  return const SizedBox.shrink(); // show NOTHING
                }

                // If data exists, take first item
                final admin = adminData.first;

                final String image = admin['image'] ?? '';
                final String name = admin['name'] ?? 'Admin';

                return Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Admin Requests:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Column(
                        children: [
                          InkWell(
                            onTap: () =>
                                context.push(RouteNames.adminrequestquestion),
                            child: image.isEmpty
                                ? const SizedBox.shrink()
                                : CircleAvatar(
                                    radius: 25,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${ImageAssetUrl.baseUrl}$image",
                                      fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) =>
                                          const SizedBox.shrink(),
                                    ),
                                  ),
                          ),
                          if (name.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(name, style: const TextStyle(fontSize: 12)),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              },
              error: (e, _) => Center(child: Text(e.toString())),
              loading: () => const SizedBox.shrink(),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                bottom: 0,
                right: 15,
                top: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Point History:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      context.push(RouteNames.allPointHistory);
                    },
                    child: Row(
                      children: const [
                        Text(
                          "View all",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.gold_coin,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: AppColors.gold_coin,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  /// POINT HISTORY
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        pointhistoryAsync.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, _) => Center(
                            child: Text(
                              error.toString(),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          data: (response) {
                            final data = response.data;
                            if (data.isEmpty) {
                              return const Text("No History Found");
                            }
                            final limitedList = data.take(5).toList();
                            return ListView.builder(
                              shrinkWrap: true,

                              padding: EdgeInsets.only(top: 10),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: limitedList.length,
                              itemBuilder: (context, index) {
                                final item = data[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: IndividualPointsCard(
                                    date: formatIsoDateForUI(
                                      item.updatedAt.toString(),
                                    ),
                                    text: item.history,
                                    status: item.status,
                                    points: item.points.toString(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (accountType == "FA")
                    familymemberpointlist.when(
                      loading: () => const SizedBox(),
                      error: (e, _) => const SizedBox(),
                      data: (familypoints) {
                        final data = familypoints.data;
                        if (data.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(15),
                            child: Text("No Family Points Found"),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Family Points",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: data.length,
                                padding: EdgeInsets.only(top: 10),
                                itemBuilder: (context, index) {
                                  final n = data[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: FamilyPointsCard(
                                      text: n.basicInfo.fullName,
                                      subtext: n.basicInfo.mobileNumber
                                          .toString(),
                                      points: n.points.toString(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
