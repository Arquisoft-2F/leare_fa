import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SectionVideo extends StatefulWidget {
  final String videoUrl;
  const SectionVideo({super.key, required this.videoUrl});

  @override
  State<SectionVideo> createState() => _SectionVideoState();
}

class _SectionVideoState extends State<SectionVideo> {
  late VideoPlayerController _controller;

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
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(
            child: Stack(
              children: [
                _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : Container(),
                // Add a Positioned widget to place the button at the center
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
