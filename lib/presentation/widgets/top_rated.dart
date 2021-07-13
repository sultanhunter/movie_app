import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/constants/constant.dart';
import 'package:movie_app/logic/cubit/gettoprated_cubit.dart';
import 'package:movie_app/presentation/screens/screens.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TopRated extends StatefulWidget {
  const TopRated({Key? key}) : super(key: key);

  @override
  State<TopRated> createState() => _TopRatedState();
}

class _TopRatedState extends State<TopRated> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: MediaQuery.of(context).size.height * 2,
      width: MediaQuery.of(context).size.width,
      // color: Colors.red,
      child: FutureBuilder(
        future: context.read<GettopratedCubit>().getTopRated(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GridView.builder(
              itemCount:
                  context.read<GettopratedCubit>().state.movieList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 3 / 5),
              itemBuilder: (context, index) {
                final String title = context
                    .read<GettopratedCubit>()
                    .state
                    .movieList
                    .elementAt(index)['original_title'];
                return InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MovieDescription(index: index);
                    }));
                  },
                  child: Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.black,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://image.tmdb.org/t/p/w500${context.read<GettopratedCubit>().state.movieList.elementAt(index)['poster_path']}'),
                          )),
                    ),
                    Positioned(
                      child: Container(
                        child: const SizedBox.shrink(),
                        height: MediaQuery.of(context).size.height * 0.38,
                        width: MediaQuery.of(context).size.width * 0.46,
                        decoration: BoxDecoration(
                          gradient: kStoryGradient,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      bottom: 0.0,
                    ),
                    Positioned(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      bottom: 10.0,
                      left: 20.0,
                    ),
                    Positioned(
                        top: 10.0,
                        right: 10.0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: Colors.black,
                          ),
                          padding: const EdgeInsets.only(
                              left: 4.0, right: 5.0, top: 4.0, bottom: 5.0),
                          child: Text(
                            '⭐ ${context.read<GettopratedCubit>().state.movieList.elementAt(index)['vote_average']}',
                            style: GoogleFonts.breeSerif(
                              color: Colors.white,
                            ),
                          ),
                        ))
                  ]),
                );
              },
            );
          }
        },
      ),
    );
  }
}
