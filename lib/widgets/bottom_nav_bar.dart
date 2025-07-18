import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_provider.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const BottomNavBar(
      {required this.currentIndex, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final tp = Provider.of<ThemeProvider>(context);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: tp.barColor,
      currentIndex: currentIndex,
      unselectedItemColor: Colors.white70,
      selectedItemColor: Colors.white,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline_rounded), label: 'Bookmarks'),
      ],
      onTap: onTap,
    );
  }
}
