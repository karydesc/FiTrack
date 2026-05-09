import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});
  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class TotalFundsContainer extends StatelessWidget {
  final int text;
  const TotalFundsContainer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Total Funds",
          textScaler: TextScaler.linear(2),
        ),
        Text(
          "$text",
          textScaler: TextScaler.linear(5),
        )
      ],
    );
  }
}

class _MainScreenState extends State<MainScreen> {
  int counter = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        titleTextStyle: TextStyle(
          fontSize: 30,
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
          child: Column(
            children: [
              TotalFundsContainer(text: counter,),
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            counter++;
          });
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.cloud), label: "mrrrw"),
            BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: "nyah"),

          ]),

    );
  }
}