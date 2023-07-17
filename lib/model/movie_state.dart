import 'movie.dart';



enum Category{
  popular,
  upcoming,
  top_rated
}

class MovieState {
  final bool isError;
  final bool isSuccess;
  final bool isLoad;
  final String errMessage;
  final List<Movie> movies;
  final Category category;
  final int page;

  MovieState({
    required this.category,
    required this.errMessage,
    required this.isError,
    required this.isSuccess,
    required this.movies,
    required this.isLoad,
    required this.page
  });


  MovieState.initState() : movies=[], isSuccess=false,errMessage='', isError=false,category= Category.popular, page=1, isLoad=false;


  MovieState copyWith ({
    bool? isError,
    bool? isSuccess,
    String? errMessage,
    List<Movie>? movies,
    Category? category,
    int? page,
    bool? isLoad
}){
    return MovieState(
        category: category ?? this.category, errMessage: errMessage ?? this.errMessage,
        isError: isError ?? this.isError , isSuccess: isSuccess ?? this.isSuccess, movies: movies ?? this.movies,
        page: page ?? this.page, isLoad: isLoad ?? this.isLoad);
  }


}