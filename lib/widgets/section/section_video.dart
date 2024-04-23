import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SectionVideo extends StatefulWidget {
  final String videoUrl;
  const SectionVideo({super.key, required this.videoUrl});

  @override
  State<SectionVideo> createState() => _SectionVideoState();
}

class _SectionVideoState extends State<SectionVideo> {
  late VideoPlayerController _controller;
  late Chewie playerWidget;
  late ChewieController chewieController;

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   chewieController.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    print("Entre a init state de section video");
    String videoUrl = widget.videoUrl;
    print(videoUrl);
    _controller = videoUrl == "Not found" || videoUrl == ''
        ? VideoPlayerController.asset('assets/test.mp4')
        : VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          final chewieController = ChewieController(
            videoPlayerController: _controller,
            autoInitialize: true,
            looping: true,
          );

          setState(() {
            playerWidget = Chewie(
              controller: chewieController,
            );
          });
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(
            child: VisibilityDetector(
              key: Key("videosection"),
              onVisibilityChanged: (VisibilityInfo info) {
                debugPrint("${info.visibleFraction} of my widget is visible");
                if (info.visibleFraction == 0) {
                  _controller.pause();
                }
              },
              child: Stack(
                children: [
                  _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: playerWidget,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
