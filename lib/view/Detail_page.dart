import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pod/constants/token.dart';
import 'package:pod/model/movie.dart';
import 'package:pod/service/movie_service.dart';
import 'package:pod/view/widgets/video_play.dart';



class DetailPage extends StatelessWidget {
  final Movie movie;
  const DetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image :  NetworkImage(  movie.backdrop_path == '' ? 'https://images.unsplash.com/photo-1688494210401-6b2de3f42208?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDMyfHFQWXNEenZKT1ljfHxlbnwwfHx8fHw%3D&auto=format&fit=crop&w=600&q=60': '$videoUrl${movie.backdrop_path}'))
        ),
        child: Consumer(
          builder: (context, ref, child) {
            final videoData = ref.watch(videoProvider(movie.id));
            final recommendData = ref.watch(recommendProvider(movie.id));
            return  Column(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  child: videoData.when(
                      data: (data){
                        return data.isEmpty ? Center(child: Text('video not available')) : PlayVideoFromNetwork(data[0].key);
                      },
                      error: (err, stack) => Center(child: Text('$err')),
                      loading: () => Container()
                  ),
                ),
                Expanded(
                  child: recommendData.when(
                      data: (data){
                        return GridView.builder(
                        itemCount: data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2 / 3,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5
                        ),
                        itemBuilder: (context, index) {
                          final movie = data[index];
                          return CachedNetworkImage(
                              errorWidget: (c,s, d){
                                return Image.asset('assets/images/movie.png');
                              },
                              placeholder: (c, s) {
                                return Center(
                                  child: SpinKitWave(
                                    color: Colors.pink,
                                    size: 25.0,
                                  ),
                                );
                              },
                              imageUrl: '$videoUrl${movie.poster_path}');
                        }
                  );
                      },
                      error: (err, stack) => Center(child: Text('$err')),
                      loading: () => Center(child: CircularProgressIndicator())
                  ),
                )
              ],
            );
          }
        ),
      ),
    );
  }
}
