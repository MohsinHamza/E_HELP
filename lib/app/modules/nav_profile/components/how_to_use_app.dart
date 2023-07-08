import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HowToUseTheApp extends StatefulWidget {
  const HowToUseTheApp({Key? key}) : super(key: key);
  @override
  HowToUseTheAppState createState() => HowToUseTheAppState();
}

class HowToUseTheAppState extends State<HowToUseTheApp> {
  late VideoPlayerController _controller;
  ChewieController? chewieController;

  initializePlayer() async {
    _controller = VideoPlayerController.network(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4");
    await _controller.initialize();
    chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: false,
      allowFullScreen: true,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('How to Use Button'),
      ),
      body: SafeArea(
        child: chewieController != null
            ? Stack(
                fit: StackFit.loose,
                alignment: Alignment.topCenter,
                children: [
                    Chewie(
                      controller: chewieController!,
                    ),
                  ])
            : const Center(
                child: AppProgressIndication(),
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    chewieController?.dispose();
  }
}

class AppProgressIndication extends StatelessWidget {
  const AppProgressIndication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.redAccent),
          )
        : const CupertinoActivityIndicator();
  }
}
