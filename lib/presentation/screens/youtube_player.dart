import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/logic/cubit/gettoprated_cubit.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Youtube extends StatefulWidget {
  final String youtubeKey;
  Youtube({Key? key, required this.youtubeKey}) : super(key: key);

  @override
  State<Youtube> createState() => _YoutubeState();
  late final YoutubePlayerController _controller;
}

class _YoutubeState extends State<Youtube> {
  @override
  void initState() {
    super.initState();
    widget._controller = YoutubePlayerController(
      initialVideoId: widget.youtubeKey,
      flags: const YoutubePlayerFlags(autoPlay: true),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // padding: const EdgeInsets.symmetric(vertical: 20.0),
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 60.0),
        alignment: Alignment.center,
        child: YoutubePlayerBuilder(
            player: YoutubePlayer(controller: widget._controller),
            builder: (context, player) {
              return Column(
                children: [
                  player,
                ],
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    widget._controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }
}
