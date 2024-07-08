import 'package:flutter/material.dart';
import 'package:summarizeai/screens/underprogress.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    currentPageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return const UnderProgress(); // Set UnderProgress as the default screen
  }
}

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}