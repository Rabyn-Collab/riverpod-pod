import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/model/movie_state.dart';
import 'package:pod/service/movie_service.dart';



final movieProvider = StateNotifierProvider((ref) => MovieProvider(MovieState.initState()));

class MovieProvider extends StateNotifier<MovieState>{
  MovieProvider(super.state);


  Future<void> getMovieByCategory(String apiPath) async{
       state = state.copyWith(isLoad: true, isSuccess: false, isError: false, errMessage: '');
     final response = await MovieService.getMovieByCategory(apiPath,  state.page);
     response.fold((l) {
       state = state.copyWith(isLoad: false, isSuccess: false, isError: true, errMessage: l);
     }, (r) => {
         state = state.copyWith(isLoad: false, isSuccess: false, isError: true, errMessage: l);
  }





}

}