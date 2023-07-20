import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pod/model/movie_state.dart';
import 'package:pod/providers/movie_provider..dart';




class TabBarWidget extends StatelessWidget {
final Categories category;

TabBarWidget(this.category);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Consumer(
          builder: (context, ref, child) {
            final movieState = category == Categories.popular ? ref.watch(popularProvider): category == Categories.top_rated ?  ref.watch(topRatedProvider) : ref.watch(upcomingProvider);
             if(movieState.isLoad){
               return Center(child: CircularProgressIndicator());
             }else if(movieState.isError){
               return Center(child: Text('${movieState.errMessage}'));
             }else{
               return Padding(
                 padding: const EdgeInsets.all(5.0),
                 child: GridView.builder(
                   key: PageStorageKey(category.name),
                     itemCount: movieState.movies.length,
                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount: 3,
                       childAspectRatio: 2/3,
                       mainAxisSpacing: 5,
                       crossAxisSpacing: 5
                     ),
                     itemBuilder: (context, index){
                       final movie = movieState.movies[index];
                       return CachedNetworkImage(
                         placeholder: (c, s){
                           return Center(
                             child: SpinKitWave(
                               color: Colors.pink,
                               size: 25.0,
                             ),
                           );
                         },
                          imageUrl: 'https://image.tmdb.org/t/p/w600_and_h900_bestv2${movie.poster_path}');
                     }
                 ),
               );
             }
          })
    ); 
  }
}
