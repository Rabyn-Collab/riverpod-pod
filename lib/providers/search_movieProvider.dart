import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/model/movie_state.dart';
import 'package:pod/service/movie_service.dart';



final searchProvider = StateNotifierProvider<MovieProvider, MovieState>((ref) => MovieProvider(MovieState.searchState()));




class MovieProvider extends StateNotifier<MovieState>{
  MovieProvider(super.state);


  Future<void> getSearchMovie(String searchText) async{
    state = state.copyWith(isLoad:   true,  errMessage: '', isError: false, isSuccess: false);
    final response = await MovieService.searchMovie(searchText, state.apiPath);
    response.fold(
            (l) {
          state = state.copyWith(isLoad:  false,  errMessage: l, isError: true, isSuccess: false);
        },
            (r)  {
          state = state.copyWith(isLoad:  false, movies: [...state.movies, ...r], errMessage: '', isError: false, isSuccess: true);
        }
    );


  }
}