import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/api.dart';
import 'package:pod/model/movie_state.dart';
import 'package:pod/service/movie_service.dart';



final movieProvider = StateNotifierProvider<MovieProvider, MovieState>((ref) => MovieProvider(MovieState.initState()));

class MovieProvider extends StateNotifier<MovieState>{
  MovieProvider(super.state){
    getMovieByCategory();
  }



   Future<void> getMovieByCategory() async{
     state = state.copyWith(isLoad:  true, movies: [], errMessage: '', isError: false, isSuccess: false);
     final response = await MovieService.getMovieByCategory(Api.getPopular, state.page);
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