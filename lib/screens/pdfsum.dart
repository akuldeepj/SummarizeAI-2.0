import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:summarizeai/screens/hh.dart';
import 'package:summarizeai/utils/Hexcolor.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:summarizeai/utils/secret.dart';
import 'package:summarizeai/screens/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfUploadPage extends StatefulWidget {
  @override
  _PdfUploadPageState createState() => _PdfUploadPageState();
}

class _PdfUploadPageState extends State<PdfUploadPage> {
  File? _selectedFile;
  String? _extractedText;
  bool _isSummaryVisible = false;

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _extractedText = null; // Reset extracted text when a new file is picked
        _isSummaryVisible = false; // Hide summary when a new file is picked
      });
    }
  }

  Future<void> _uploadPDF() async {
    if (_selectedFile == null) {
      // Handle case when no file is selected
      return;
    }

    var uri = Uri.parse('$IPAddress/api/pdfsummary'); // Replace with your server endpoint

    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'pdfFile',
        _selectedFile!.path,
      ));

    var response = await request.send();

    if (response.statusCode == 200) {
      // File uploaded successfully
      var responseBody = await response.stream.bytesToString();
      setState(() {
        _extractedText = json.decode(responseBody)['text'];
        _isSummaryVisible = true; // Show summary when text is extracted
      });

      // Save history
      String pdfLink = _selectedFile!.path; // You might want to use a proper link here
      await saveHistory(pdfLink, _extractedText!);
    } else {
      // Error uploading file
      print('Failed to upload file');
      print(response.reasonPhrase);
    }
  }

  Future<void> saveHistory(String link, String summary) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('history') ?? [];
    final date = DateTime.now().toString();
    history.insert(0, '$link|$summary|$date');
    await prefs.setStringList('history', history);
  }

  void _openPdfViewer() {
    if (_selectedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => hh(file: _selectedFile!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      drawer: navbar(),
      appBar: AppBar(title: Text('PDF Summary'),),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 5), // Adjust the height to move everything down
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: screenSize.width * 0.45, // Adjust button width here
                          child: ElevatedButton(
                            onPressed: _pickPDF,
                            child: Text('Select PDF', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15.0), // Adjust button height
                              backgroundColor: Color.fromARGB(255,26,67,78),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10), // Add spacing between buttons
                        Container(
                          width: screenSize.width * 0.45, // Adjust button width here
                          child: ElevatedButton(
                            onPressed: _uploadPDF,
                            child: Text('Upload PDF', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15.0), // Adjust button height
                              backgroundColor: Color.fromARGB(255,26,67,78),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_selectedFile != null)
                    GestureDetector(
                      onTap: _openPdfViewer,
                      child: Container(
                        height: 500, // Increase the height of the PDF viewer
                        child: SfPdfViewer.file(
                          _selectedFile!,
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                  // Summary display
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: screenSize.width - 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255,245,246,250),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Summary will appear here:',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _isSummaryVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isSummaryVisible = !_isSummaryVisible;
                                  });
                                },
                              ),
                            ],
                          ),
                          if (_isSummaryVisible && _extractedText != null)
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromARGB(255,245,246,250),
                                  ),
                                  child: Text(
                                    _extractedText!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}