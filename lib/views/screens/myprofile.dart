// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:nadi_user_app/core/constants/app_consts.dart';
// import 'package:nadi_user_app/core/network/dio_client.dart';
// import 'package:nadi_user_app/core/utils/logger.dart';
// import 'package:nadi_user_app/providers/profile_provider.dart';
// import 'package:nadi_user_app/routing/app_router.dart';
// import 'package:nadi_user_app/widgets/app_back.dart';
// import 'package:nadi_user_app/widgets/inputs/app_text_field.dart';

// class Myprofile extends ConsumerWidget {
//   const Myprofile({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final profileAsyncValue = ref.watch(profileprovider);

//     return Scaffold(
//       backgroundColor: AppColors.background_clr,
//       body: profileAsyncValue.when(
//         data: (profileResponse) {
//           if (profileResponse == null) {
//             AppLogger.error("Profile response is null");
//             return const Center(child: Text("No profile data"));
//           }

//           final basicData =
//               profileResponse['data'] as Map<String, dynamic>? ?? {};
//           final addresses = profileResponse['addresses'] as List? ?? [];
//           final familyMembers = profileResponse['familyMembers'] as List? ?? [];

//           String safeString(dynamic value) => value?.toString() ?? "";

//           final nameCtrl = TextEditingController(
//             text: safeString(basicData['basicInfo']?['fullName']),
//           );
//           final emailCtrl = TextEditingController(
//             text: safeString(basicData['basicInfo']?['email']),
//           );
//           final phoneCtrl = TextEditingController(
//             text: safeString(basicData['basicInfo']?['mobileNumber']),
//           );
//           final addressCtrl = TextEditingController(
//             text: addresses.isNotEmpty ? safeString(addresses[0]['city']) : "",
//           );

//           return Column(
//             children: [
//               // Header
//               Container(
//                 height: 200,
//                 width: double.infinity,
//                 padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       const Color.fromRGBO(76, 149, 129, 1),
//                       const Color.fromRGBO(117, 192, 172, 1),
//                     ],
//                   ),
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(51),
//                     bottomRight: Radius.circular(51),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         AppCircleIconButton(
//                           icon: Icons.arrow_back,
//                           onPressed: () => context.push(RouteNames.bottomnav),
//                           color: const Color.fromRGBO(183, 213, 205, 1),
//                         ),
//                         const Text(
//                           "Profile Details",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const Text(""),
//                       ],
//                     ),
//                     const SizedBox(height: 30),
//                     Container(
//                       height: 62,
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(30),
//                         color: const Color.fromRGBO(13, 95, 72, 1),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               basicData['basicInfo']?['image'] == null ||
//                                       basicData['basicInfo']!['image']
//                                           .toString()
//                                           .isEmpty
//                                   ? const CircleAvatar(
//                                       radius: 22,
//                                       backgroundColor: Colors.blue,
//                                       child: Icon(
//                                         Icons.person,
//                                         color: Colors.white,
//                                         size: 20,
//                                       ),
//                                     )
//                                   : CircleAvatar(
//                                       radius: 22,
//                                       backgroundColor: Colors.transparent,
//                                       backgroundImage: CachedNetworkImageProvider(
//                                         "${ImageBaseUrl.baseUrl}/${basicData['basicInfo']!['image']}",
//                                       ),
//                                     ),
//                               const SizedBox(width: 12),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text(
//                                     "Welcome",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 13,
//                                     ),
//                                   ),
//                                   Text(
//                                     nameCtrl.text.isNotEmpty
//                                         ? nameCtrl.text
//                                         : "Loading...",
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           InkWell(
//                             onTap: () async {
//                               final profileDataForEdit = {
//                                 "data": basicData,
//                                 "addresses": addresses,
//                                 "familyMembers": familyMembers,
//                               };

//                               final result = await context.push<bool>(
//                                 RouteNames.editprfoile,
//                                 extra: profileDataForEdit,
//                               );

//                               if (result == true) {
//                                 ref.refresh(profileprovider);
//                               }
//                             },
//                             child: Container(
//                               height: 38,
//                               width: 38,
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.white,
//                               ),
//                               child: const Icon(
//                                 Icons.edit_outlined,
//                                 color: AppColors.button_secondary,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Body
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 15,
//                       vertical: 25,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Full Name",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         AppTextField(
//                           controller: nameCtrl,
//                           readonly: true,
//                           enabled: false,
//                         ),
//                         const SizedBox(height: 15),
//                         const Text(
//                           "Email Address",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         AppTextField(
//                           controller: emailCtrl,
//                           readonly: true,
//                           enabled: false,
//                         ),
//                         const SizedBox(height: 15),
//                         const Text(
//                           "Phone Number",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         AppTextField(
//                           controller: phoneCtrl,
//                           readonly: true,
//                           enabled: false,
//                         ),
//                         const SizedBox(height: 15),
//                         const Text(
//                           "Address",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         AppTextField(
//                           minLines: 3,
//                           maxLines: 5,
//                           controller: addressCtrl,
//                           readonly: true,
//                           enabled: false,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//         loading: () => const SizedBox(),
//         error: (err, stack) {
//           AppLogger.error("Riverpod profileprovider error: $err");
//           return const Center(child: Text("Error loading profile"));
//         },
//       ),
//     );
//   }
// }




import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/providers/profile_provider.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/widgets/app_back.dart';
import 'package:nadi_user_app/widgets/inputs/app_text_field.dart';

class Myprofile extends ConsumerWidget {
  const Myprofile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsyncValue = ref.watch(profileprovider);

    return Scaffold(
      backgroundColor:Theme.of(context).scaffoldBackgroundColor,
      body: profileAsyncValue.when(
        data: (profileResponse) {
          if (profileResponse == null) {
            AppLogger.error("Profile response is null");
            return const Center(child: Text("No profile data"));
          }

          final basicData =
              profileResponse['data'] as Map<String, dynamic>? ?? {};
          final addresses = profileResponse['addresses'] as List? ?? [];
          final familyMembers = profileResponse['familyMembers'] as List? ?? [];

          String safeString(dynamic value) => value?.toString() ?? "";

          final nameCtrl = TextEditingController(
            text: safeString(basicData['basicInfo']?['fullName']),
          );
          final emailCtrl = TextEditingController(
            text: safeString(basicData['basicInfo']?['email']),
          );
          final phoneCtrl = TextEditingController(
            text: safeString(basicData['basicInfo']?['mobileNumber']),
          );
          final addressCtrl = TextEditingController(
            text: addresses.isNotEmpty ? safeString(addresses[0]['city']) : "",
          );

          return Column(
            children: [
              // Header
              Container(
                height: 180, // slightly reduced height
                width: double.infinity,
                padding: const EdgeInsets.only(top: 35, left: 15, right: 15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(76, 149, 129, 1),
                      Color.fromRGBO(117, 192, 172, 1),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(51),
                    bottomRight: Radius.circular(51),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppCircleIconButton(
                          icon: Icons.arrow_back,
                          onPressed: () => context.push(RouteNames.bottomnav),
                          color: const Color.fromRGBO(183, 213, 205, 1),
                        ),
                        const Text(
                          "Profile Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 38), // to balance space
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 58, // reduced height
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromRGBO(13, 95, 72, 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              basicData['basicInfo']?['image'] == null ||
                                      basicData['basicInfo']!['image']
                                          .toString()
                                          .isEmpty
                                  ? const CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.blue,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: CachedNetworkImageProvider(
                                        "${ImageBaseUrl.baseUrl}/${basicData['basicInfo']!['image']}",
                                      ),
                                    ),
                              const SizedBox(width: 10), // reduced
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Welcome",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    nameCtrl.text.isNotEmpty
                                        ? nameCtrl.text
                                        : "Loading...",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () async {
                              final profileDataForEdit = {
                                "data": basicData,
                                "addresses": addresses,
                                "familyMembers": familyMembers,
                              };

                              final result = await context.push<bool>(
                                RouteNames.editprfoile,
                                extra: profileDataForEdit,
                              );

                              if (result == true) {
                                ref.refresh(profileprovider);
                              }
                            },
                            child: Container(
                              height: 36, // reduced size
                              width: 36,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.edit_outlined,
                                color: AppColors.button_secondary,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Body
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15), // reduced vertical padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Full Name",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4), // reduced
                        AppTextField(
                          controller: nameCtrl,
                          readonly: true,
                          enabled: false,
                        ),
                        const SizedBox(height: 10), // reduced
                        const Text(
                          "Email Address",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AppTextField(
                          controller: emailCtrl,
                          readonly: true,
                          enabled: false,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Phone Number",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AppTextField(
                          controller: phoneCtrl,
                          readonly: true,
                          enabled: false,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Address",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AppTextField(
                          minLines: 3,
                          maxLines: 5,
                          controller: addressCtrl,
                          readonly: true,
                          enabled: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          AppLogger.error("Riverpod profileprovider error: $err");
          return const Center(child: Text("Error loading profile"));
        },
      ),
    );
  }
}

