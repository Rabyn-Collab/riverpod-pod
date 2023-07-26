import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:pod/model/movie_state.dart';
import 'package:pod/view/search_page.dart';
import 'package:pod/view/widgets/tab_bar-Widgets.dart';




class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          flexibleSpace: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('TMDB MOVIE', style: TextStyle(color: Colors.pink, fontSize: 27),),
                  IconButton(onPressed: (){
                    Get.to(() => SearchPage(), transition: Transition.leftToRight);
                  }, icon: Icon(Icons.search))
                ],
              ),
            ),
          ),
          bottom: TabBar(
             labelColor: Colors.pinkAccent,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(text: 'Popular',),
                Tab(text: 'TopRated',),
                Tab(text: 'UpComing',),
              ]
          ),
        ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),

              children: [
               TabBarWidget(Categories.popular),
               TabBarWidget(Categories.top_rated),
               TabBarWidget(Categories.upcoming),

          ])
      ),
    );
  }
}
