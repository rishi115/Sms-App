import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sms/screens/home_screen.dart';
import 'package:sms/screens/messages_screen.dart';
import 'package:sms/screens/schedule_screen.dart';
import 'package:sms/screens/settings_screen%20copy.dart';
import 'package:sms/screens/profile_screen.dart'; // Import the Profile screen

class NavBarRoots extends StatefulWidget {
  const NavBarRoots({super.key});

  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  int _selectedIndex = 0;
  final _screens = [
    HomeScreen(),
    MessagesScreen(),
    ScheduleScreen(),
    SettingScreen(),
    ProfileScreen(), // Add the Profile screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color.fromARGB(255, 111, 210, 235),
          unselectedItemColor: Colors.black26,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble_text_fill),
                label: "Messages"),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined), label: "Schedule"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Profile"), // Add Profile icon
          ],
        ),
      ),
    );
  }
}
