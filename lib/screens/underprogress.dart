import 'package:flutter/material.dart';
import 'package:summarizeai/screens/pdfsum.dart';
import 'package:summarizeai/screens/yt_sum.dart';
import 'package:summarizeai/screens/flowchart.dart';
import 'package:summarizeai/utils/Hexcolor.dart';
import 'package:summarizeai/screens/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class UnderProgress extends StatefulWidget {
  const UnderProgress({Key? key}) : super(key: key);

  @override
  _UnderProgressState createState() => _UnderProgressState();
}

class _UnderProgressState extends State<UnderProgress> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  List<String> history = [];
  List<bool> _expandedFlags = []; // Track expansion state for each history item

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyList = prefs.getStringList('history') ?? [];
    setState(() {
      history = historyList;
      _expandedFlags = List<bool>.filled(historyList.length, false); // Initialize with false
    });
  }

  void _handleSwipe(DragEndDetails details) {
    if (details.primaryVelocity! < 0) {
      _controller.animateTo(
        0.9,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (details.primaryVelocity! > 0) {
      _controller.animateTo(
        0.1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navbar(),
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Get your personalised summary here!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => YtSum()),
                        ).then((_) {
                          _loadHistory();
                        });
                      },
                      child: Card(
                        color: const Color.fromARGB(255, 229,222, 246),
                        margin: const EdgeInsets.all(10),
                        child: Container(
                        padding: const EdgeInsets.all(20),
                        constraints: const BoxConstraints(minHeight: 220),
                        child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Padding(
                        padding: EdgeInsets.only(left: 6.0, top: 40.0),
                        child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(
                        Icons.video_library,
                        size: 30,
                        color: Color.fromARGB(255, 26, 67, 78),
                        ),
                        ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                        "Youtube video",
                        style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        ),
                        ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                        "Paste video link",
                        style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 83, 83, 83),
                        ),
                        ),
                        ),
                        ],
                        ),
                        ),
                        ),
                        ),
                        ),
                        Expanded(
                        child: GestureDetector(
                        onTap: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => PdfUploadPage()),
                        );
                        },
                        child: Card(
                        color: const Color.fromARGB(255, 250, 243, 235),
                        margin: const EdgeInsets.all(10),
                        child: Container(
                        padding: const EdgeInsets.all(20),
                        constraints: const BoxConstraints(minHeight: 220),
                        child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Padding(
                        padding: EdgeInsets.only(left: 6.0, top: 40.0),
                        child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(
                        Icons.download,
                        size: 30,
                        color: Color.fromARGB(255, 26, 67, 78),
                        ),
                        ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                        "Pick a file",
                        style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        ),
                        ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                        "Upload your PDF file",
                        style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 83, 83, 83),
                        ),
                        ),
                        ),
                        ],
                        ),
                        ),
                        ),
                        ),
                        ),
                        ],
                        ),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        child: GestureDetector(
                        onTap: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => MindMapApp()),
                        );
                        },
                        child: Card(
                        color: const Color.fromARGB(255, 235, 250, 239),
                        margin: const EdgeInsets.all(10),
                        child: Container(
                        padding: const EdgeInsets.all(20),
                        constraints: const BoxConstraints(minHeight: 150),
                        child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Padding(
                        padding: EdgeInsets.only(left: 6.0),
                        child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(
                        Icons.insert_chart,
                        size: 30,
                        color: Color.fromARGB(255, 26, 67, 78),
                        ),
                        ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                        "Flowchart",
                        style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        ),
                        ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                        "Create a mind map",
                        style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 83, 83, 83),
                        ),
                        ),
                        ),
                        ],
                        ),
                        ),
                        ),
                        ),
                        ),
                        ],
                        ),
                        ],
                        ),
                        DraggableScrollableSheet(
                        controller: _controller,
                        initialChildSize: 0.1,
                        minChildSize: 0.1,
                        maxChildSize: 0.9,
                        builder:
                        (BuildContext context, ScrollController scrollController) {
                        return GestureDetector(
                        onVerticalDragEnd: (details) => _handleSwipe(details),
                        child: Container(
                        decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        boxShadow: [
                        BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                        offset: Offset(2.0, 2.0),
                        ),
                        ],
                        ),
                        child: Column(
                        children: [
                        Container(
                        padding: const EdgeInsets.all(20),
                        child: const Text(
                        "History",
                        style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        ),
                        ),
                        ),
                        Expanded(
                        child: ListView.builder(
                        controller: scrollController,
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                        final entry = history[index].split('|');
                        final link = entry[0];
                        final summary = entry[1];
                        final date = DateTime.parse(entry[2]);
                        final dayMonth = DateFormat('MMM dd').format(date);
                        final time = DateFormat('HH:mm').format(date); // Ensure time is formatted correctly

                        bool showDate = true;
                        if (index > 0) {
                          final previousEntry = history[index - 1].split('|');
                          final previousDate = DateTime.parse(previousEntry[2]);
                          showDate = DateFormat('MMM dd').format(previousDate) != dayMonth;
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (showDate)
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                                child: Text(
                                  dayMonth,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ListTile(
                              title: Text(link, style: TextStyle(color: Colors.blue)),
                              trailing: Text(time), // Ensure the time is displayed on the right
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Summary:', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 26, 67, 78))),
                                  IconButton(
                                    icon: Icon(
                                      _expandedFlags[index]
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _expandedFlags[index] = !_expandedFlags[index];
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            if (_expandedFlags[index])
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Card(
                                  color: Colors.white, // Change the card color here
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(summary),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
        ],
      ),
      ),
    );
  },
),
],
),
);
}
}

void main() {
runApp(const MaterialApp(
home: UnderProgress(),
));
}