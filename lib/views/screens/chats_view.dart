import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/widgets/app_back.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: AppColors.background_clr,
    floatingActionButton:   SizedBox(
      height: 49,
      width: 49,
      child: FloatingActionButton(
       onPressed: (){},
        backgroundColor: Color.fromRGBO(13, 95, 72, 100),
        shape: CircleBorder(),
        child: Icon(Icons.add,color: Colors.white,size: 30,),
        ),
    ),

       body: SafeArea(
         child: Column(
          children: [
             Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 20,
                  bottom: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppCircleIconButton(icon: Icons.arrow_back, onPressed: () {context.pop(context);}),
                   const Text(
                      "Chats",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                   const Text(""),
                   const Text("")
                  ],
                ),
              ),
              Divider(),
       Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  child: Container(
    height: 50,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: Colors.white,
    ),
    child: Row(
      children: [
        const SizedBox(width: 15),

        const Icon(
          Icons.search,
          color: Colors.grey,
          size: 22,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: "Search Message...",
              hintStyle: TextStyle(color: Colors.grey,fontSize: AppFontSizes.small),
              border: InputBorder.none, // removes underline
            ),
          ),
        ),
      ],
    ),
  ),
),

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 17,vertical: 10),
  child: Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 30,
            child: ClipOval(
              child: Image.asset(
                "assets/images/service.png",
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
            ),
          ),
          const SizedBox(width: 15),
  
          // Name + Message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Sara Ali",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(
                  "Hey Hii There what up Where are you..",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
  
          const SizedBox(width: 10),
  
          // Time + Unread Dot
          Column(
           
            children: [
              Text(
                "10:30 AM",
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(13, 95, 72, 1),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
),

const Spacer(),

          ],
         ),
 

         
       ),
    );
  }
}