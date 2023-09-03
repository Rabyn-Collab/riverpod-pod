import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/common_widgets/snack_widget.dart';
import 'package:pod/constants/gap.dart';
import 'package:pod/providers/auth_provider.dart';
import 'package:pod/providers/post_provider.dart';
import 'package:pod/service/auth_service.dart';
import 'package:pod/service/post_service.dart';
import 'package:pod/view/crud/add_page.dart';
import 'package:pod/view/crud/update_page.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:pod/view/detail_page.dart';
import 'package:pod/view/user_detail.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

 late types.User user;


  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
      final usersData = ref.watch(usersStream);
      final userData = ref.watch(singleUserStream(uid));
      final postData = ref.watch(postsStream);
        return Scaffold(
            appBar: AppBar(
              title: Text('Sample Social'),
            ),
            drawer: Drawer(
              child: userData.when(
                  data: (data){
                    user= data;
                    return ListView(
                      children: [
                        DrawerHeader(
                            decoration: BoxDecoration(
                              image: DecorationImage(image: NetworkImage(data.imageUrl!))
                            ),
                            child: Text(data.metadata!['email'])),
                        ListTile(
                          onTap: (){
                            Get.back();
                            Get.to(() => AddPage());
                          },
                          leading: Icon(Icons.add),
                          title: Text('create post'),

                        ),
                        ListTile(
                          onTap: (){
                            ref.read(authProvider.notifier).userLogOut();
                          },
                          leading: Icon(Icons.exit_to_app),
                          title: Text('userLogOut'),
                        ),

                      ],
                    );
                  }, error: (err, stack){
                    return Text('$err');

              }, loading: () => Center(child: CircularProgressIndicator())
              )
            ),
            body: Column(
              children: [
                Container(
                  height: 150,
                  padding: EdgeInsets.all(10),
                  child: usersData.when(
                      data: (data){
                        return ListView.builder(
                          itemCount: data.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index){
                            return InkWell(
                              onTap: (){
                                Get.to(() => UserDetail(user: data[index]));
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(data[index].imageUrl!),
                                  ),
                                  Sizes.gapH10,
                                  Text(data[index].firstName!),
                                ],
                              ),
                            );
                            }
                        );
                      },
                      error: (err, stack) => Center(child: Text('$err')),
                      loading: () => Center(child: CircularProgressIndicator())
                  ),
                ),

                Expanded(child: postData.when(
                    data: (data){
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text(data[index].title)),
                                    if(uid == data[index].userId) IconButton(
                                         padding: EdgeInsets.zero,
                                         constraints: BoxConstraints(),
                                         onPressed: (){
                                           Get.defaultDialog(
                                             title: 'Customize post',
                                             content: Text('Edit or remove post'),
                                             actions: [
                                               IconButton(onPressed: (){
                                                 Navigator.of(context).pop();
                                                 Get.to(() => UpdatePage(data[index]));
                                               }, icon: Icon(Icons.edit)),
                                               IconButton(onPressed: (){
                                                 Navigator.of(context).pop();
                                                 Get.defaultDialog(
                                                   title: 'Hold On',
                                                   content: Text('Are you sure to remove this post'),
                                                   actions: [
                                                     TextButton(onPressed: (){}, child: Text('yes')),
                                                     TextButton(onPressed: (){}, child: Text('no')),
                                                   ]
                                                 );
                                               }, icon: Icon(Icons.delete)),
                                             ]
                                           );
                                         }, icon: Icon(Icons.more_horiz_outlined))
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    Get.to(() => DetailPage(data[index].postId, user));
                                  },
                                  child: Container(
                                      height: 300,
                                      width: double.infinity,
                                      child: Image.network(data[index].imageUrl, fit: BoxFit.cover,)),
                                ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        if(data[index].like.likes > 0)  Text(data[index].like.likes.toString(), style: TextStyle(fontSize: 20),),
                                       if(uid != data[index].userId) IconButton(onPressed: (){
                                          if(data[index].like.users.contains(user.firstName)){
                                            CommonSnack.errrorSnack(context: context, msg: 'you have already like this post');
                                          }else{
                                            print('hello');
                                            ref.read(postProvider.notifier).likePost(
                                                username: user.firstName!,
                                                oldLike: data[index].like.likes,
                                                postId: data[index].postId
                                            );
                                          }
                                        }, icon: Icon(Icons.thumb_up_outlined)),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            );
                          }
                        ),
                      );
                    },
                    error: (err, stack) => Text('$err'),
                    loading: () => Center(child: CircularProgressIndicator())
                ))
              ],
            )
        );
      }
    );
  }
}
