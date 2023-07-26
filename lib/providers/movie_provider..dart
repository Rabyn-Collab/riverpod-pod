import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/model/movie_state.dart';
import 'package:pod/service/movie_service.dart';



final popularProvider = StateNotifierProvider<MovieProvider, MovieState>((ref) => MovieProvider(MovieState.initState()));
final topRatedProvider = StateNotifierProvider<MovieProvider, MovieState>((ref) => MovieProvider(MovieState.initState1()));
final upcomingProvider = StateNotifierProvider<MovieProvider, MovieState>((ref) => MovieProvider(MovieState.initState2()));

class MovieProvider extends StateNotifier<MovieState>{
  MovieProvider(super.state){
    getMovieByCategory();
  }



   Future<void> getMovieByCategory() async{
     state = state.copyWith(isLoad:state.isLoadMore ? false:  true,  errMessage: '', isError: false, isSuccess: false);
     final response = await MovieService.getMovieByCategory(state.apiPath, state.page);
     response.fold(
             (l) {
               state = state.copyWith(isLoad:  false,  errMessage: l, isError: true, isSuccess: false);
             },
             (r)  {
               state = state.copyWith(isLoad:  false, movies: [...state.movies, ...r], errMessage: '', isError: false, isSuccess: true);
             }
     );


   }

  void loadMore() {
state = state.copyWith(isLoadMore: true, page: state.page + 1);
getMovieByCategory();

  }

}