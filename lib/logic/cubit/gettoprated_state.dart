part of 'gettoprated_cubit.dart';

class GettopratedState extends Equatable {
  final List movieList;
  const GettopratedState(this.movieList);

  @override
  List<Object> get props => [movieList];
}

class GettopratedInitial extends GettopratedState {
  const GettopratedInitial(List movieList) : super(movieList);
}
