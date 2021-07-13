import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/logic/cubit/gettoprated_cubit.dart';
import 'package:movie_app/presentation/widgets/top_rated.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<GettopratedCubit>().getTopRated();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Top Rated 10 Movies',
            style: GoogleFonts.breeSerif(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        // body: StreamBuilder()const TopRated(),
        body: StreamBuilder<ConnectivityResult>(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, snapshot) {
              if (snapshot.data == ConnectivityResult.none) {
                return const Center(
                  child: Text('No internet'),
                );
              } else {
                return const TopRated();
              }
            }),
      ),
    );
  }
}
