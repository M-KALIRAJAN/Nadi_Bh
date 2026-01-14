import 'package:flutter/material.dart';
import 'package:nadi_user_app/views/screens/dashborad.dart';
import 'package:nadi_user_app/views/screens/point_details.dart';


class HomeTabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Function(int) onTabChange;

  const HomeTabNavigator({
    super.key,
    required this.navigatorKey,
    required this.onTabChange,
  });

 Future<bool> showCustomExitDialog(BuildContext context) async {
  bool exitApp = false;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            const  Text(
                "Do you want to exit the app?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),

            const  SizedBox(height: 25),

              Row(
              mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      exitApp = false;
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
    const SizedBox(width: 20,),
                  // Exit button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      exitApp = true;
                    },
                    child: const Text(
                      "Exit",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  return exitApp;
}


  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: "/home",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/home":
            return MaterialPageRoute(
              builder: (_) => Dashboard(onTabChange: onTabChange),
            );
    
          case "/pointdetails":
            return MaterialPageRoute(
              builder: (_) => PointDetails(),
            );
    
          default:
            return MaterialPageRoute(
              builder: (_) => Dashboard(onTabChange: onTabChange),
            );
        }
      },
    );
  }
}


