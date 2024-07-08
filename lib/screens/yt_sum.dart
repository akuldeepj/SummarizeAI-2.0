import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:summarizeai/screens/underprogress.dart';
import 'package:summarizeai/utils/Hexcolor.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:summarizeai/utils/secret.dart';
import 'package:summarizeai/screens/navbar.dart';

class YtSum extends StatefulWidget {
  const YtSum({Key? key}) : super(key: key);

  @override
  _YtSumState createState() => _YtSumState();
}

class _YtSumState extends State<YtSum> {
  late YoutubePlayerController _controller;
  String finalsum = 'Your summary will appear here';
  final _textController = TextEditingController();
  bool _isSummaryVisible = false;
  bool _isSummaryReady = false;

  Future<String> getVideoSummary(String videoLink) async {
    final response = await http.post(
      Uri.parse('$IPAddress/api/get_yt_summary'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'link': videoLink}),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['summary'];
    } else {
      throw Exception('Failed to load summary');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      drawer: navbar(),
      appBar: AppBar(title: Text('Youtube Video Summary'),),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 5), // Move everything down
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    top: 20.0,
                    bottom: 15.0,
                  ),
                  child: SizedBox(
                    height: 80,
                    width: screenSize.width - 30, // Increase the width of the text field box
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Paste the YouTube video link here',
                        hintStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255,26,67,78),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onSubmitted: (value) async {
                        var videoId = YoutubePlayer.convertUrlToId(value);
                        if (videoId != null) {
                          _controller.load(videoId);
                          String summary = await getVideoSummary(value);
                          setState(() {
                            finalsum = summary;
                            _isSummaryVisible = true; // Show the summary when it's ready
                            _isSummaryReady = true;  // Enable the arrow button
                          });
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: screenSize.width - 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: HexColor('#6D90DC'),
                    ),
                    child: YoutubePlayer(controller: _controller),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10.0), // Decrease the padding
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255,245,246,250),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Summary will appear here:',
                                  style: const TextStyle(color: Colors.black, fontSize: 16),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _isSummaryVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                                onPressed: _isSummaryReady
                                    ? () {
                                        setState(() {
                                          _isSummaryVisible = !_isSummaryVisible;
                                        });
                                      }
                                    : null, // Disable button if summary is not ready
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isSummaryVisible)
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 35,
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255,245,246,250),
                        ),
                        child: Text(
                          finalsum,
                          style: const TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: YtSum(),
  ));
}