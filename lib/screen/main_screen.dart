import 'package:desk_timer/screen/clock_screen.dart';
import 'package:desk_timer/screen/rest_screen.dart';
import 'package:desk_timer/screen/timer_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _widgetList = [
    const ClockScreen(),
    const RestScreen(),
    const TimerScreen(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _widgetList,
        ),
        bottomNavigationBar: _navigationBar(),
      ),
    );
  }

  BottomNavigationBar _navigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black54,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      enableFeedback: false,
      iconSize: 30.0,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.punch_clock),
          label: 'Clock',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.lock_clock),
          label: 'Rest',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer),
          label: 'Timer',
        ),
      ],
    );
  }
}
