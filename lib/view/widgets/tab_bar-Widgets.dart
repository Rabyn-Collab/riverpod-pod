import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/providers/movie_provider..dart';




class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key});

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
        body: Consumer(
          builder: (context, ref, child) {
            final movieState = ref.watch(movieProvider);
             if(movieState.isLoad){
               return Center(child: CircularProgressIndicator());
             }else if(movieState.isError){
               return Center(child: Text('${movieState.errMessage}'));
             }else{
               return Padding(
                 padding: const EdgeInsets.all(5.0),
                 child: GridView.builder(
                     itemCount: movieState.movies.length,
                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount: 3,
                       childAspectRatio: 2/3,
                       mainAxisSpacing: 5,
                       crossAxisSpacing: 5
                     ),
                     itemBuilder: (context, index){
                       final movie = movieState.movies[index];
                       return Image.network('https://image.tmdb.org/t/p/w600_and_h900_bestv2${movie.poster_path}');
                     }
                 ),
               );
             }
          })
    ); 
  }
}
