import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;



final roomProvider = StreamProvider((ref) => FirebaseChatCore.instance.rooms());
final msgStream = StreamProvider.family((ref,types.Room room) => FirebaseChatCore.instance.messages(room));


final chats = Provider((ref) => ChatProvider());



class ChatProvider {


  Future createRoom(types.User user) async{
      try{
        final room = await FirebaseChatCore.instance.createRoom(user);
        return room;
      }catch(err){
         return 'something went wrong';
      }
  }


}