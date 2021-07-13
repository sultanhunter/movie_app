import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/constants/constant.dart';
import 'package:movie_app/logic/cubit/gettoprated_cubit.dart';
import 'package:movie_app/presentation/screens/youtube_player.dart';

class MovieDescription extends StatefulWidget {
  final int index;
  MovieDescription({Key? key, required this.index}) : super(key: key);

  late final String title;
  late final String description;
  late final String bannerUrl;
  late final String posterUrl;
  late final double vote;
  late final String launchDate;

  @override
  State<MovieDescription> createState() => _MovieDescriptionState();
}

class _MovieDescriptionState extends State<MovieDescription> {
  @override
  void initState() {
    super.initState();
    widget.title = context
        .read<GettopratedCubit>()
        .state
        .movieList
        .elementAt(widget.index)['original_title'];
    widget.description = context
        .read<GettopratedCubit>()
        .state
        .movieList
        .elementAt(widget.index)['overview'];
    widget.bannerUrl =
        'https://image.tmdb.org/t/p/w500${context.read<GettopratedCubit>().state.movieList.elementAt(widget.index)['backdrop_path']}';
    widget.posterUrl =
        'https://image.tmdb.org/t/p/w500${context.read<GettopratedCubit>().state.movieList.elementAt(widget.index)['poster_path']}';
    widget.vote = context
        .read<GettopratedCubit>()
        .state
        .movieList
        .elementAt(widget.index)['vote_average'];
    widget.launchDate = context
        .read<GettopratedCubit>()
        .state
        .movieList
        .elementAt(widget.index)['release_date'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          widget.title,
          style: GoogleFonts.breeSerif(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<ConnectivityResult>(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            if (snapshot.data == ConnectivityResult.none) {
              return const Center(
                child: Text('No internet'),
              );
            } else {
              return Container(
                child: ListView(
                  children: [
                    Container(
                      height: 250,
                      child: Stack(
                        children: [
                          Container(
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              widget.bannerUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            height: 250,
                            decoration: const BoxDecoration(
                              gradient: kStoryGradient,
                            ),
                          ),
                          Positioned(
                            bottom: 10.0,
                            left: 10.0,
                            child: Text(
                              '⭐ Average Rating - ${widget.vote}',
                              style: GoogleFonts.breeSerif(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10.0,
                            left: 10.0,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                      widget.posterUrl,
                                    ),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              height: 200,
                              width: 150,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        widget.title,
                        style: GoogleFonts.breeSerif(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Launch Date - ${widget.launchDate}',
                              style: GoogleFonts.breeSerif(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.red),
                              onPressed: () async {
                                final String youtubeKey = await context
                                    .read<GettopratedCubit>()
                                    .getVideo(context
                                        .read<GettopratedCubit>()
                                        .state
                                        .movieList
                                        .elementAt(widget.index)['id']);
                                if (youtubeKey == '') {
                                  return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Alert'),
                                          content:
                                              const Text('No videos found'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Okay'))
                                          ],
                                        );
                                      });
                                } else {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Youtube(youtubeKey: youtubeKey);
                                  }));
                                }
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Play Trailer'),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        widget.description,
                        style: GoogleFonts.breeSerif(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
