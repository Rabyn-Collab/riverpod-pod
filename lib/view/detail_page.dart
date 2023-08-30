import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/common_widgets/snack_widget.dart';
import 'package:pod/constants/gap.dart';
import 'package:pod/model/post.dart';
import 'package:pod/providers/post_provider.dart';
import 'package:pod/service/post_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


class DetailPage extends StatelessWidget {
  final String id;
  final types.User user;
  DetailPage(this.id, this.user);
final textControl = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Consumer(
      builder: (context, ref, child) {
        final postData = ref.watch(postStream(id));
        return Scaffold(
          resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: postData.when(
                  data: (data){
               return  Column(
                 children: [
                   Image.network(data.imageUrl),
                   Sizes.gapH10,
                   Padding(
                     padding: const EdgeInsets.all(10.0),
                     child: TextFormField(
                       controller: textControl,
                       onFieldSubmitted: (val){
                         if(val.isEmpty){
                           CommonSnack.errrorSnack(context: context, msg: 'add somes');
                         }else{
                           ref.read(postProvider.notifier).commentPost(
                               comment: Comment(
                                   comment:val.trim(),
                                   userImage: user.imageUrl!,
                                   username: user.firstName!
                               ),
                               postId: data.postId
                           );
                           textControl.clear();
                         }
                       },
                       //maxLines: 3,
                       decoration: InputDecoration(
                         hintText: 'add some comment',
                          border: OutlineInputBorder()
                       ),
                     ),
                   ),
                   Sizes.gapH10,
                   Expanded(
                       child: Padding(
                         padding: const EdgeInsets.all(10.0),
                         child: ListView.builder(
                           shrinkWrap: true,
                    itemCount: data.comments.length,
                           itemBuilder: (context, index){
                    final e = data.comments[index];
                             return ListTile(
                               leading: Image.network(e.userImage),
                               title: Text(e.username),
                               subtitle: Text(e.comment),
                             );
                           }),
                       ),
                       )
                   
                 ],
               );
                  },
                  error: (err, stack) => Center(child: Text('$err')),
                  loading: () => Center(child: CircularProgressIndicator())
              ),
            )
        );
      }
    );
  }
}
