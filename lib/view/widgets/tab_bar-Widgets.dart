import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:pod/constants/token.dart';
import 'package:pod/model/movie_state.dart';
import 'package:pod/providers/movie_provider..dart';
import 'package:pod/view/Detail_page.dart';




class TabBarWidget extends StatelessWidget {
final Categories category;
late  bool result;
TabBarWidget(this.category);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: OfflineBuilder(
      connectivityBuilder: (
      BuildContext context,
      ConnectivityResult connectivity,
      Widget child,
    ) {
      if(connectivity == ConnectivityResult.wifi || connectivity == ConnectivityResult.mobile){
        result = true;
      }else{
        result= false;
      }
     print(result);
        return Consumer(
            builder: (context, ref, child) {
              final movieState = category == Categories.popular ? ref.watch(
                  popularProvider) : category == Categories.top_rated ? ref
                  .watch(topRatedProvider) : ref.watch(upcomingProvider);
              if (movieState.isLoad) {
                return Center(child: CircularProgressIndicator());
              } else if (movieState.isError) {
                return Center(child: Text('${movieState.errMessage}'));
              } else {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: NotificationListener(
                    onNotification: (onNotification) {
                      if (onNotification is ScrollEndNotification) {
                        final before = onNotification.metrics.extentBefore;
                        final max = onNotification.metrics.maxScrollExtent;
                        if (before == max) {
                          switch (category) {
                            case Categories.popular:
                              ref.read(popularProvider.notifier).loadMore();
                            case Categories.top_rated:
                              ref.read(topRatedProvider.notifier).loadMore();
                            case Categories.upcoming:
                              ref.read(upcomingProvider.notifier).loadMore();
                          }
                        }
                      }
                      return true;
                    },
                    child: GridView.builder(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                            .onDrag,
                        key: PageStorageKey(category.name),
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
                    ),
                  ),
                );
              }
            });
      },
          child: Container(),
        )
    ); 
  }
}
