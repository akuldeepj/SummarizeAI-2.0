import 'package:flutter/material.dart';
import 'package:summarizeai/screens/pdfsum.dart';
import 'package:summarizeai/screens/underprogress.dart';
import 'package:summarizeai/screens/yt_sum.dart';

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
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.primary,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.youtube_searched_for),
            label: 'Youtube',
          ),
          NavigationDestination(icon: Icon(Icons.picture_as_pdf), label: 'Pdf'),

        ],
      ),
      appBar: AppBar(
        title: currentPageIndex == 0
            ? const Text('Home')
            : currentPageIndex == 1
                ? const Text('Youtube')
                : const Text('Pdf'),
      ),
      body: currentPageIndex == 0
          ? UnderProgress()
          : currentPageIndex == 1
              ? YtSum()
              : PdfUploadPage(),
    );
  }
}
