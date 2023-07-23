import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/constants/token.dart';
import 'package:pod/model/movie.dart';
import 'package:pod/service/movie_service.dart';
import 'package:pod/view/widgets/video_play.dart';



class DetailPage extends StatelessWidget {
  final Movie movie;
  const DetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage('$videoUrl${movie.backdrop_path}'))
      ),
      child: ListView(
        children: [
         Consumer(
           builder: (context, ref, child) {
             final videoData = ref.watch(videoProvider(movie.id));
             return  Container(
               height: 300,
               width: double.infinity,
               child: videoData.when(
                   data: (data){
                     return PlayVideoFromNetwork(data[0].key);
                   },
                   error: (err, stack) => Center(child: Text('$err')),
                   loading: () => Container()
               ),
             );
           }
         )

        ],
      ),
    );
  }
}
