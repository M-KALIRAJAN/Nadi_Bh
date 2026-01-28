import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/core/utils/Time_Date.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/providers/family_member_points_list.dart';
import 'package:nadi_user_app/providers/fetchpointsnodification.dart';
import 'package:nadi_user_app/providers/fetchrequestspeoplelist_provider.dart';
import 'package:nadi_user_app/providers/pointshistory_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUserData();
    Future.microtask(() {
      ref.refresh(pointshistoryprovider);
      ref.refresh(fetchpointsnodification);
      ref.refresh(FamilymemberpointslistProvider);
      ref.refresh(fetchrequestpeoplelistprovider);
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
  ) async {
    final result = await context.push(
      RouteNames.requestPeopleDetails,
      extra: {'peopleId': peopleId, 'fullName': fullName},
    );

    if (result == true && mounted) {
      ref.refresh(pointshistoryprovider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pointhistoryAsync = ref.watch(pointshistoryprovider);
    final notificationCount = ref.watch(fetchpointsnodification);
    final familymemberpointlist = ref.watch(FamilymemberpointslistProvider);

    final requestedpointspeoplelist = ref.watch(fetchrequestpeoplelistprovider);

    return Scaffold(
      backgroundColor: AppColors.background_clr,
      body: Column(
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
                      "Profile Details",
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    const Icon(Icons.person),
                                          ),
                                        ),
                                      ),

                                const SizedBox(width: 10),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
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

                      Center(
                        child: Text(
                          points.toString(),
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
              final list = people.length > 7 ? people.take(7).toList() : people;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: const Text(
                      "Points Requests:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: people.length > 7
                        ? list.length + 1
                        : list.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.68,
                        ),
                    itemBuilder: (context, index) {
                      if (people.length > 7 && index == list.length) {
                        return Column(
                          children: const [
                            CircleAvatar(
                              radius: 24,
                              child: Icon(Icons.keyboard_arrow_down),
                            ),
                            SizedBox(height: 4),
                            Text("Show More", style: TextStyle(fontSize: 11)),
                          ],
                        );
                      }
                      final item = list[index];
                      return Column(
                        children: [
                          // _peopledetails(context, item.id,item.basicInfo.fullName);
                          InkWell(
                            onTap: () {
                              _peopledetails(
                                context,
                                item.id,
                                item.basicInfo.fullName,
                              );
                            },
                            child: CircleAvatar(
                              radius: 24,
                              child: Text(
                                item.basicInfo.fullName.isNotEmpty
                                    ? item.basicInfo.fullName[0].toUpperCase()
                                    : "?",
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.basicInfo.fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 0, right: 15),
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

          Expanded(
            child: SingleChildScrollView(
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
                            final limitedList = data.take(8).toList();
                            return ListView.builder(
                              shrinkWrap: true,
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
          ),
        ],
      ),
    );
  }
}
