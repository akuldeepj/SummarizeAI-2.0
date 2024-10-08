import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:summarizeai/utils/secret.dart';
import 'package:summarizeai/screens/navbar.dart';

class MindMapApp extends StatelessWidget {
  const MindMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MindMapScreen();
  }
}

class MindMapScreen extends StatefulWidget {
  const MindMapScreen({super.key});

  @override
  State<MindMapScreen> createState() => _MindMapScreenState();
}

class _MindMapScreenState extends State<MindMapScreen> with SingleTickerProviderStateMixin {
  WebViewController? _controller;
  String _mindMapCode = '';
  late AnimationController _animationController;
  late Animation<double> _animation;
  File? _selectedFile;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadPDF() async {
    if (_selectedFile == null) {
      // Handle case when no file is selected
      return;
    }

    var uri = Uri.parse('$IPAddress/generate-mind-map'); // Replace with your server endpoint

    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'pdfFile',
        _selectedFile!.path,
      ));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      setState(() {
        _mindMapCode = json.decode(responseBody)['mind_map_code'];
        _loadMindMap();
      });
    } else {
      print('Failed to upload file');
      print(response.reasonPhrase);
    }
  }

  void _loadMindMap() async {
    if (_mindMapCode.isNotEmpty) {
      final String htmlContent = """
        <!DOCTYPE html>
        <html>
        <head>
          <script type="module">
            import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
            mermaid.initialize({startOnLoad:true});
          </script>
          <style>
            body, html {
              margin: 0;
              padding: 0;
              width: 100%;
              height: 100%;
              overflow: hidden;
            }
            .mermaid {
              width: 100%;
              height: 100%;
              display: flex;
              justify-content: center;
              align-items: center;
            }
          </style>
        </head>
        <body>
          <div class="mermaid">
            $_mindMapCode
          </div>
        </body>
        </html>
      """;

      final filePath = await _writeHtmlToFile(htmlContent);
      _controller?.loadUrl(Uri.file(filePath).toString());
    }
  }

  Future<String> _writeHtmlToFile(String htmlContent) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/mind_map.html';
    final file = File(filePath);
    await file.writeAsString(htmlContent);
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      drawer: navbar(),
      appBar: AppBar(title: Text('Mind Map'),),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 5),
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: screenSize.width * 0.45,
                          child: ElevatedButton(
                            onPressed: _pickPDF,
                            child: Text('Select PDF', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              backgroundColor: Color.fromARGB(255, 26, 67, 78),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: screenSize.width * 0.45,
                          child: ElevatedButton(
                            onPressed: _uploadPDF,
                            child: Text('Upload PDF', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              backgroundColor: Color.fromARGB(255, 26, 67, 78),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_selectedFile != null)
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 500,
                        child: SfPdfViewer.file(_selectedFile!),
                      ),
                    ),
                  SizedBox(height: 20),
                  if (_mindMapCode.isNotEmpty)
                    FadeTransition(
                      opacity: _animation,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: WebView(
                          initialUrl: 'about:blank',
                          onWebViewCreated: (controller) {
                            _controller = controller;
                            _loadMindMap();
                          },
                          javascriptMode: JavascriptMode.unrestricted,
                          gestureNavigationEnabled: true,
                          zoomEnabled: true,
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