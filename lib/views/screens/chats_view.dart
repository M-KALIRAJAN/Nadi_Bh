// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:nadi_user_app/core/constants/app_consts.dart';
// import 'package:nadi_user_app/providers/Chats_List_Provider.dart';
// import 'package:nadi_user_app/providers/connectivity_provider.dart';
// import 'package:nadi_user_app/widgets/app_back.dart';
// import 'package:nadi_user_app/widgets/no_internet_widget.dart';

// class ChatsView extends ConsumerStatefulWidget {
//   const ChatsView({super.key});

//   @override
//   ConsumerState<ChatsView> createState() => _ChatsViewState();
// }

// class _ChatsViewState extends ConsumerState<ChatsView> {
//   @override
//   void initState() {
//     super.initState();
//     ref.refresh(fetchchatslistprovider);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final chatlist = ref.watch(fetchchatslistprovider);
//     final connectivity = ref.watch(connectivityProvider);

//     return Scaffold(
//       backgroundColor: AppColors.background_clr,

//       // floatingActionButton: SizedBox(
//       //   height: 49,
//       //   width: 49,
//       //   child: FloatingActionButton(
//       //     onPressed: () {},
//       //     backgroundColor: const Color.fromRGBO(13, 95, 72, 1),
//       //     shape: const CircleBorder(),
//       //     child: const Icon(Icons.add, color: Colors.white, size: 30),
//       //   ),
//       // ),
//       body: connectivity.when(
//         data: (isOnline) {
//           if (!isOnline) {
//             return const NoInternetScreen();
//           }
//           return SafeArea(
//             child: Column(
//               children: [
//                 /// TOP BAR
//                 Padding(
//                   padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       AppCircleIconButton(
//                         icon: Icons.arrow_back,
//                         onPressed: () => context.pop(),
//                       ),
//                       const Text(
//                         "Chats",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 20,
//                         ),
//                       ),
//                       const SizedBox(),
//                     ],
//                   ),
//                 ),

//                 const Divider(),

//                 /// SEARCH
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 15,
//                     vertical: 10,
//                   ),
//                   child: Container(
//                     height: 50,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       color: Colors.white,
//                     ),
//                     child: Row(
//                       children: const [
//                         SizedBox(width: 15),
//                         Icon(Icons.search, color: Colors.grey, size: 22),
//                         SizedBox(width: 10),
//                         Expanded(
//                           child: TextField(
//                             decoration: InputDecoration(
//                               hintText: "Search Message...",
//                               border: InputBorder.none,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 /// CHAT LIST FROM API
//                 Expanded(
//                   child: chatlist.when(
//                     /// LOADING
//                     loading: () =>
//                         const Center(child: CircularProgressIndicator()),

//                     /// ERROR
//                     error: (err, stack) => Center(child: Text(err.toString())),

//                     /// DATA
//                     data: (chatModel) {
//                       final chats = chatModel.data ?? [];

//                       if (chats.isEmpty) {
//                         return const Center(child: Text("No chats found"));
//                       }

//                       return ListView.builder(
//                         itemCount: chats.length,
//                         itemBuilder: (context, index) {
//                           final user = chats[index];

//                           return InkWell(
//                             // CLICK NAVIGATION
//                             onTap: () {
//                               context.push(
//                                 "/chatDetails",
//                                 extra: {"id": user.id, "name": user.name},
//                               );
//                             },

//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 17,
//                                 vertical: 10,
//                               ),

//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   /// AVATAR
//                                   CircleAvatar(
//                                     radius: 25,
//                                     backgroundColor: const Color.fromRGBO(
//                                       13,
//                                       95,
//                                       72,
//                                       1,
//                                     ),
//                                     child: Text(
//                                       (user.name != null &&
//                                               user.name!.isNotEmpty)
//                                           ? user.name![0].toUpperCase()
//                                           : "?",
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 22,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 15),

//                                   /// NAME + MESSAGE
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           user.name ?? "",
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),

//                                         const SizedBox(height: 3),

//                                         Text(
//                                           user.lastMessage?.message ??
//                                               "No messages",
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),

//                                   /// UNREAD DOT
//                                   if (user.lastMessage?.read == false)
//                                     Container(
//                                       height: 12,
//                                       width: 12,
//                                       decoration: const BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: Color.fromRGBO(13, 95, 72, 1),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, s) => const NoInternetScreen(),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/providers/Chats_List_Provider.dart';
import 'package:nadi_user_app/providers/connectivity_provider.dart';
import 'package:nadi_user_app/widgets/app_back.dart';
import 'package:nadi_user_app/widgets/no_internet_widget.dart';

class ChatsView extends ConsumerStatefulWidget {
  const ChatsView({super.key});

  @override
  ConsumerState<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends ConsumerState<ChatsView> {

  /// ✅ SEARCH CONTROLLER
  final TextEditingController searchController = TextEditingController();
  String searchText = "";

  @override
  void initState() {
    super.initState();
    ref.refresh(fetchchatslistprovider);
  }

  @override
  Widget build(BuildContext context) {

    final chatlist = ref.watch(fetchchatslistprovider);
    final connectivity = ref.watch(connectivityProvider);

    return Scaffold(
      backgroundColor: AppColors.background_clr,

      body: connectivity.when(
        data: (isOnline) {

          if (!isOnline) {
            return const NoInternetScreen();
          }

          return SafeArea(
            child: Column(
              children: [

                /// TOP BAR
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppCircleIconButton(
                        icon: Icons.arrow_back,
                        onPressed: () => context.pop(),
                      ),
                      const Text(
                        "Chats",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(),
                    ],
                  ),
                ),

                const Divider(),

                /// ✅ SEARCH BAR
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 15),
                        const Icon(Icons.search, color: Colors.grey, size: 22),
                        const SizedBox(width: 10),

                        Expanded(
                          child: TextField(
                              showCursor: false,
                            controller: searchController,
                            onChanged: (value) {
                              setState(() {
                                searchText = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: "Search Message...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// CHAT LIST FROM API
                Expanded(
                  child: chatlist.when(

                    /// LOADING
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),

                    /// ERROR
                    error: (err, stack) =>
                        Center(child: Text(err.toString())),

                    /// DATA
                    data: (chatModel) {

                      final chats = chatModel.data ?? [];

                      /// ✅ AUTO SEARCH FILTER
                      final filteredChats = chats.where((user) {
                        final name = user.name?.toLowerCase() ?? "";
                        return name.contains(searchText.toLowerCase());
                      }).toList();

                      if (filteredChats.isEmpty) {
                        return const Center(child: Text("No chats found"));
                      }

                      return ListView.builder(
                        itemCount: filteredChats.length,
                        itemBuilder: (context, index) {

                          final user = filteredChats[index];

                          return InkWell(
                            onTap: () {
                              context.push(
                                "/chatDetails",
                                extra: {
                                  "id": user.id,
                                  "name": user.name
                                },
                              );
                            },

                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 17,
                                vertical: 10,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  /// AVATAR
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: const Color.fromRGBO(
                                      13,
                                      95,
                                      72,
                                      1,
                                    ),
                                    child: Text(
                                      (user.name != null &&
                                              user.name!.isNotEmpty)
                                          ? user.name![0].toUpperCase()
                                          : "?",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 15),

                                  /// NAME + MESSAGE
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [

                                        Text(
                                          user.name ?? "",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        const SizedBox(height: 3),

                                        Text(
                                          user.lastMessage?.message ??
                                              "No messages",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// UNREAD DOT
                                  if (user.lastMessage?.read == false)
                                    Container(
                                      height: 12,
                                      width: 12,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(13, 95, 72, 1),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },

        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => const NoInternetScreen(),
      ),
    );
  }
}

