import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:pod/constants/token.dart';
import 'package:pod/providers/search_movieProvider.dart';
import 'package:pod/view/Detail_page.dart';



class SearchPage extends StatelessWidget {

  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Consumer(
            builder: (context, ref, child) {
              final movieState = ref.watch(searchProvider);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    TextFormField(
                      controller: searchController,
                      onFieldSubmitted: (val){
                        ref.read(searchProvider.notifier).getSearchMovie(val.trim());
                        searchController.clear();

                      },
                      autofocus: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        hintText: 'searchMovies',
                        border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 50,),
                    Expanded(child: movieState.isLoad ? Center(child: CircularProgressIndicator()) : movieState.isError ? Center(child: Text(movieState.errMessage)):
                    GridView.builder(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                            .onDrag,
                        itemCount: movieState.movies.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2 / 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5
                        ),
                        itemBuilder: (context, index) {
                          final movie = movieState.movies[index];
                          return InkWell(
                            onTap: () {
                              Get.to(() => DetailPage(movie: movie),
                                  transition: Transition.leftToRight);
                            },
                            child: CachedNetworkImage(
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
                                imageUrl: '$videoUrl${movie.poster_path}'),
                          );
                        }
                    )
                    )
                  ],
                ),
              );
            }
          ),
        )
    );
  }
}
