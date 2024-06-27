import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class MindMapApp extends StatelessWidget {
  const MindMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Scaffold(
        body: SafeArea(child: MindMapScreen()),
      ),
    );
  }
}

class MindMapScreen extends StatefulWidget {
  const MindMapScreen({super.key});

  @override
  State<MindMapScreen> createState() => _MindMapScreenState();
}

class _MindMapScreenState extends State<MindMapScreen> with SingleTickerProviderStateMixin {
  late final WebViewController _controller;
  String _mindMapCode = '';
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _fetchMindMapCode();

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

  Future<void> _fetchMindMapCode() async {
    final response = await http.post(
      Uri.parse('http://192.168.0.101:8000/generate-mind-map'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'text': """
        In the heart of a bustling city, where towering skyscrapers cast long shadows over narrow alleyways, lived a reclusive inventor named Theo. Theo spent his days tinkering in a cluttered workshop, creating whimsical gadgets that fascinated the neighborhood children. One rainy evening, while experimenting with an old pocket watch, Theo accidentally discovered a way to momentarily freeze time. Delighted by his find, he ventured out into the rain-slick streets, using his newfound power to help strangers in small but meaningful ways—rescuing a kitten from a tree, returning a lost wallet, and even saving a child from a speeding car. As dawn approached and the city began to stir, Theo returned to his workshop, content in knowing that his quiet existence had touched many lives, even if they never knew it was him.
        """,
        'api_key': 'your_api_key_here',
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _mindMapCode = jsonDecode(response.body)['mind_map_code'];
        _loadMindMap();
      });
    } else {
      throw Exception('Failed to load mind map code');
    }
  }

  void _loadMindMap() {
    if (_mindMapCode.isNotEmpty) {
      final String htmlContent = """
        <!DOCTYPE html>
        <html>
        <head>
          <script type="module">
            import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
            mermaid.initialize({startOnLoad:true});
          </script>
        </head>
        <body>
          <div class="mermaid">
            $_mindMapCode
          </div>
        </body>
        </html>
      """;

      _writeHtmlToFile(htmlContent).then((filePath) {
        _controller.loadFile(filePath);
      });
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mind Map Viewer', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _animation,
        child: WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: (controller) {
            _controller = controller;
          },
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
