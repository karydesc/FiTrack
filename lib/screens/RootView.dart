import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:personalfinancetracker/screens/StatisticsScreen.dart";
import "HistoryScreen.dart";
import "MainScreen.dart";

class RootView extends StatefulWidget {
  RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  int selectedPage = 0;
  final List<Widget> pages = [MainScreen(title: "FiTrack"), HistoryScreen(), StatisticsScreen()];
  @override
  Widget build(BuildContext contex) {
    return Scaffold(
      body: pages[selectedPage],

      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => {
          setState(() {
            selectedPage = index;
          }),
        },
        currentIndex: selectedPage,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Statistics",
          ),
        ],
      ),
    );
  }
}
