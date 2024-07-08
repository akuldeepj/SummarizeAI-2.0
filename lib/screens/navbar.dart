import 'package:flutter/material.dart';
import 'package:summarizeai/screens/underprogress.dart';
import 'package:summarizeai/screens/flowchart.dart';
import 'package:summarizeai/screens/pdfsum.dart';
import 'package:summarizeai/screens/yt_sum.dart';

class navbar extends StatelessWidget {
  const navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Change the background color of the Drawer
      child: Container(
        color: Color.fromARGB(255,26,67,78), // Set the color as per your design
        child: Padding(
          // Add padding at the top
          padding: const EdgeInsets.only(top: 50), // Adjust the padding as needed
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.home,color:Colors.white),
                title: Text('Home', style:TextStyle(color: Colors.white)),
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UnderProgress())),
              ),
              ListTile(
                leading: Icon(Icons.download,color:Colors.white),
                title: Text('PDF Summary', style:TextStyle(color: Colors.white)),
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PdfUploadPage())),
              ),
              ListTile(
                leading: Icon(Icons.video_library,color:Colors.white),
                title: Text('Youtube Video Summary', style:TextStyle(color: Colors.white)),
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => YtSum())),
              ),
              ListTile(
                leading: Icon(Icons.insert_chart,color:Colors.white),
                title: Text('Mind Map', style:TextStyle(color: Colors.white)),
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MindMapApp())),
              )
            ],
          ),
        ),
      )
    );
  }
}