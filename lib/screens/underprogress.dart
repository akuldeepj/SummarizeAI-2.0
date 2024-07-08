import 'package:flutter/material.dart';
import 'package:summarizeai/screens/pdfsum.dart';
import 'package:summarizeai/screens/yt_sum.dart';
import 'package:summarizeai/screens/flowchart.dart';
import 'package:summarizeai/utils/Hexcolor.dart';
import 'package:summarizeai/screens/navbar.dart';

class UnderProgress extends StatelessWidget {
  const UnderProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navbar(),
      appBar: AppBar(title: Text('Home'),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 40), // Adjust the height to move the text up
          const Padding(
            padding: EdgeInsets.only(left: 20.0), // Move the text to the right
            child: Text(
              'Get your personalised summary here!',
              style: TextStyle(
                fontSize: 28, // Increase the font size
                fontWeight: FontWeight.bold, // Make the text bold
              ),
            ),
          ),
          const SizedBox(height: 30), // Add a small gap between text and cards
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => YtSum()),
                    );
                  },
                  child: Card(
                    color: Color.fromARGB(255,229,222,246),  // Set the new background color for the card
                    margin: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      constraints: const BoxConstraints(minHeight: 220),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 6.0, top: 40.0),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.video_library, size: 30, color: Color.fromARGB(255,26,67,78)), // Change the icon color
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Youtube video',
                              style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Paste video link',
                              style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 83, 83, 83)),
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
                      MaterialPageRoute(builder: (context) => PdfUploadPage()),
                    );
                  },
                  child: Card(
                    color: Color.fromARGB(255,250,243,235),
                    margin: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      constraints: const BoxConstraints(minHeight: 220), // Set minimum height
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 6.0, top: 40.0),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.download, size: 30, color: Color.fromARGB(255,26,67,78)),
                            ),
                          ),
                          SizedBox(height: 10), // Add some space between the icon and the texts
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Pick a file',
                              style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Upload your PDF file',
                              style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 83, 83, 83)),
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
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 1, // Adjust the width as needed
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MindMapApp()),
                    );
                  },
                  child: Card(
                    color: Color.fromARGB(255,235,250,239),
                    margin: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      constraints: const BoxConstraints(minHeight: 150), // Set minimum height
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.insert_chart, size: 30, color: Color.fromARGB(255,26,67,78)),
                            ),
                          ),
                          SizedBox(height: 10), // Add some space between the icon and the texts
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Flowchart',
                              style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Create a mind map',
                              style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 83, 83, 83)),
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
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: UnderProgress(),
  ));
}