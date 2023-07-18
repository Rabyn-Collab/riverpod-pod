import 'package:flutter/material.dart';
import 'package:pod/view/widgets/tab_bar-Widgets.dart';




class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  IconButton(onPressed: (){}, icon: Icon(Icons.search))
                ],
              ),
            ),
          ),
          bottom: TabBar(
             labelColor: Colors.pinkAccent,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(text: 'Popular',),
                Tab(text: 'UpComing',),
                Tab(text: 'TopRated',),
              ]
          ),
        ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),

              children: [
               TabBarWidget(),
               TabBarWidget(),
               TabBarWidget(),

          ])
      ),
    );
  }
}
