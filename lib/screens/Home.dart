import 'package:flutter/material.dart';
import 'package:summarizeai/screens/pdfsum.dart';
import 'package:summarizeai/screens/underprogress.dart';
import 'package:summarizeai/screens/yt_sum.dart';
import 'package:summarizeai/utils/Hexcolor.dart';
import 'package:summarizeai/screens/flowchart.dart';

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
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
    navigationBarTheme: NavigationBarThemeData(
      labelTextStyle: MaterialStateProperty.all<TextStyle>(
        TextStyle(color: Colors.black), // Set your desired color here
      ),),),
        child: NavigationBar(
          backgroundColor: HexColor('#ffe4c4'),
          elevation: 0,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
              
            });
          },
          indicatorColor: Colors.black,
          selectedIndex: currentPageIndex,
          destinations:  <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home, color: currentPageIndex == 0 ? HexColor('#c49450') : Colors.black),
              icon: Icon(Icons.home_outlined, color: currentPageIndex == 0 ? HexColor('#c49450') : Colors.black),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.youtube_searched_for, color: currentPageIndex == 1 ? HexColor('#c49450') : Colors.black),
              icon: Icon(Icons.youtube_searched_for, color: currentPageIndex == 1 ? HexColor('#c49450') : Colors.black),
              label: 'Youtube',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.picture_as_pdf, color: currentPageIndex == 2 ? HexColor('#c49450') : Colors.black),
              icon: Icon(Icons.picture_as_pdf, color: currentPageIndex == 2 ? HexColor('#c49450') : Colors.black),
              label: 'Pdf'),
              NavigationDestination(
              selectedIcon: Icon(Icons.picture_as_pdf, color: currentPageIndex == 3 ? HexColor('#c49450') : Colors.black),
              icon: Icon(Icons.picture_as_pdf, color: currentPageIndex == 3 ? HexColor('#c49450') : Colors.black),
              label: 'Flow Chart'),
        
          ],
        ),
      ),
     appBar: AppBar(
  backgroundColor: HexColor('#ffe4c4'),
  title: Builder(
    builder: (context) {
      if (currentPageIndex == 0) {
        return const Text('Home', style: TextStyle(color: Colors.black));
      } else if (currentPageIndex == 1) {
        return const Text('Youtube', style: TextStyle(color: Colors.black));
      } else if (currentPageIndex == 2){
        return const Text('Pdf', style: TextStyle(color: Colors.black));
      } else {
        return const Text('Flow Chart', style: TextStyle(color: Colors.black));
      }

    },
  ),
),
body: Builder(
  builder: (context) {
    if (currentPageIndex == 0) {
      return UnderProgress();
    } else if (currentPageIndex == 1) {
      return YtSum();
    } else if (currentPageIndex == 2) {
      return PdfUploadPage();
    } else {
      return MindMapApp();
    }
  },
),);
  }
}
