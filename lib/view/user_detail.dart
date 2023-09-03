import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/constants/gap.dart';
import 'package:pod/providers/chat_roooms_provider.dart';
import 'package:pod/service/auth_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:pod/view/chat.dart';

class UserDetail extends StatelessWidget {
  final types.User user;
  const UserDetail({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Consumer(
                builder: (context, ref, child) {
                  print(user.id);
                  final postStream = ref.watch(userPostStream(user.id));
                  return Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(user.imageUrl!),

                          ),
                          Sizes.gapW10,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text(user.firstName!),
                              Text(user.metadata!['email']),
                              ElevatedButton(
                                  onPressed: () async{
                                final room = await ref.read(chats).createRoom(user);
                                Get.to(() => ChatPage(room: room));
                              }, child: Text('Chat'))
                            ],),
                          )
                        ],
                      ),
                     Expanded(
                         child: postStream.when(
                         data: (data){
                           print(data);
                           return GridView.builder(
                               itemCount: data.length,
                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                               crossAxisCount: 2),
                               itemBuilder: (context, index){
                                 return Image.network(data[index].imageUrl);
                               }
                           );
                         },
                         error: (err, stack) => Center(child: Text('$err')),
                         loading: () => Center(child: CircularProgressIndicator())
                     )),
                    ],
                  );
                }
    ),
          ),
        )
    );
  }
}
