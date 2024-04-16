//create a stateful widget and post the data to the server and fetch the summary of the video

import 'package:flutter/material.dart';
import 'package:summarizeai/utils/Hexcolor.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YtSum extends StatefulWidget {
  const YtSum({Key? key}) : super(key: key);

  @override
  _YtSumState createState() => _YtSumState();
}

class _YtSumState extends State<YtSum> {
  late YoutubePlayerController _controller;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'iL1jv9mZqBc',
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
      body: Column(
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     controller: _textController,
          //     decoration: InputDecoration(
          //       labelText: 'Enter Youtube Video Link',
          //     ),
          //     onSubmitted: (value) {
          //       var videoId = YoutubePlayer.convertUrlToId(value);
          //       if (videoId != null) {
          //         _controller.load(videoId);
          //       }
          //     },
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 20.0, bottom: 10),
            child: SizedBox(
              height: 50,
              width: screenSize.width < 950
                  ? screenSize.width - 150
                  : screenSize.width - 400,
              child: TextField(
                controller: _textController,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'Paste the youtube video link here',
                  hintStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  filled: true,
                  fillColor: HexColor('#6D90DC'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onSubmitted: (value) {
                  var videoId = YoutubePlayer.convertUrlToId(value);
                  if (videoId != null) {
                    _controller.load(videoId);
                  }
                },
              ),
            ),
          ),
          YoutubePlayer(controller: _controller),
        ],
      ),
    );
  }
}
