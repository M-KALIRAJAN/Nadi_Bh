import 'package:flutter/material.dart';

import 'package:nadi_user_app/views/screens/chats_view.dart';
import 'package:nadi_user_app/views/screens/my_service_request.dart';
import 'package:nadi_user_app/views/screens/myprofile.dart';
import 'package:nadi_user_app/views/screens/settings_view.dart';
import 'package:nadi_user_app/widgets/HomeTabNavigator .dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  DateTime? lastBackPressed;

  final homeNavigatorKey = GlobalKey<NavigatorState>();
  late final List<Widget Function()> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      () => HomeTabNavigator(
        navigatorKey: homeNavigatorKey,
        onTabChange: changeTab,
      ),
      () => MyServiceRequest(),
      () => ChatsView(),
      () => Myprofile(),
      () => SettingsView(),
    ];
  }

  void changeTab(int index) {
    setState(() => _selectedIndex = index);
  }

  /// BACK BUTTON HANDLER
  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() => _selectedIndex = 0);
      return false;
    }

    if (homeNavigatorKey.currentState != null &&
        homeNavigatorKey.currentState!.canPop()) {
      homeNavigatorKey.currentState!.pop();
      return false;
    }

    DateTime now = DateTime.now();
    if (lastBackPressed == null ||
        now.difference(lastBackPressed!) > const Duration(seconds: 2)) {
      lastBackPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tap again to exit"),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          bottom: true,
          top: false,
          child: screens[_selectedIndex](),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBottomNav() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 85,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color.fromARGB(255, 223, 219, 219).withOpacity(0.6)
                : Colors.black12,
            blurRadius: isDark ? 12 : 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedItemColor: const Color(0xFF0F7757),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          showUnselectedLabels: true,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 28),
              activeIcon: Icon(Icons.home, size: 28),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/icons/services.png"),
                size: 28,
              ),
              label: "My Request",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/icons/chat.png"), size: 28),
              label: "Live Chat",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/icons/profile.png"), size: 28),
              label: "Profile",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/icons/setting.png"), size: 28),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
