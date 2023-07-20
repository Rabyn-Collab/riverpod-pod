import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/model/movie_state.dart';
import 'package:pod/service/movie_service.dart';



final popularProvider = StateNotifierProvider<MovieProvider, MovieState>((ref) => MovieProvider(MovieState.initState()));
final topRatedProvider = StateNotifierProvider<MovieProvider, MovieState>((ref) => MovieProvider(MovieState.initState1()));
final upcomingProvider = StateNotifierProvider<MovieProvider, MovieState>((ref) => MovieProvider(MovieState.initState2()));

class MovieProvider extends StateNotifier<MovieState>{
  MovieProvider(super.state){
    print('call this');
    getMovieByCategory();
  }



   Future<void> getMovieByCategory() async{
     state = state.copyWith(isLoad:  true, movies: [], errMessage: '', isError: false, isSuccess: false);
     final response = await MovieService.getMovieByCategory(state.apiPath, state.page);
     response.fold(
             (l) {
               state = state.copyWith(isLoad:  false, movies: [], errMessage: l, isError: true, isSuccess: false);
             },
             (r)  {
               state = state.copyWith(isLoad:  false, movies: r, errMessage: '', isError: false, isSuccess: true);
             }
     );


   }




}