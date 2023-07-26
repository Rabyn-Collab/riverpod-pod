import 'package:pod/api.dart';

import 'movie.dart';



enum Categories{
  popular,
  upcoming,
  top_rated
}

class MovieState {
  final bool isError;
  final bool isSuccess;
  final bool isLoad;
  final bool isLoadMore;
  final String errMessage;
  final List<Movie> movies;
  final String apiPath;
  final int page;

  MovieState({
    required this.apiPath,
    required this.errMessage,
    required this.isError,
    required this.isSuccess,
    required this.movies,
    required this.isLoad,
    required this.page,
    required this.isLoadMore
  });


  MovieState.initState() : movies=[], isSuccess=false,errMessage='', isError=false,apiPath=Api.getPopular,
        page=1, isLoad=false, isLoadMore=false;
  MovieState.initState1() : movies=[], isSuccess=false,errMessage='',
        isLoadMore=false,
        isError=false,apiPath=Api.getTopRated, page=1, isLoad=false;
  MovieState.initState2() : movies=[], isSuccess=false,errMessage='',
        isLoadMore=false,
        isError=false,apiPath=Api.getUpcoming, page=1, isLoad=false;

  MovieState.searchState() : movies=[], isSuccess=false,errMessage='',
        isLoadMore=false,
        isError=false,apiPath=Api.getSearchMovie, page=1, isLoad=false;



  MovieState copyWith ({
    bool? isError,
    bool? isSuccess,
    String? errMessage,
    List<Movie>? movies,
    String? apiPath,
    int? page,
    bool? isLoad,
    bool? isLoadMore
}){
    return MovieState(
       apiPath: apiPath ?? this.apiPath,
        errMessage: errMessage ?? this.errMessage,
        isLoadMore: isLoadMore ?? this.isLoadMore,
        isError: isError ?? this.isError , isSuccess: isSuccess ?? this.isSuccess, movies: movies ?? this.movies,
        page: page ?? this.page, isLoad: isLoad ?? this.isLoad);
  }


}