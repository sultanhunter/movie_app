import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/config/api.dart';

part 'gettoprated_state.dart';

class GettopratedCubit extends Cubit<GettopratedState> {
  GettopratedCubit() : super(const GettopratedInitial([]));

  final Api _api = Api();

  Future<List> getTopRated() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=${_api.getApiKey}&language=en-US&page=1'));

    final body = response.body;
    Map<String, dynamic> mainBody = jsonDecode(body);
    final List topRatedMoviesList = mainBody['results'];
    List topRatedTenMoviesList = [];
    for (int i = 0; i < 10; i++) {
      topRatedTenMoviesList.insert(i, topRatedMoviesList[i]);
    }
    emit(GettopratedState(topRatedTenMoviesList));
    return topRatedTenMoviesList;
  }

  Future<String> getVideo(int id) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/$id/videos?api_key=${_api.getApiKey}&language=en-US'),
    );
    Map<String, dynamic> mainBody = jsonDecode(response.body);
    final List videosList = mainBody['results'];
    late final String youtubeKey;
    if (videosList.isEmpty) {
      youtubeKey = '';
    } else {
      youtubeKey = videosList.elementAt(0)['key'];
    }

    return youtubeKey;
  }
}
