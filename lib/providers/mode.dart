import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';



final loginProvider = StateNotifierProvider.autoDispose<LoginProvider, bool>((ref) => LoginProvider(true));


class LoginProvider extends StateNotifier<bool>{
  LoginProvider(super.state);

  void changeState(){
    state = !state;
  }


}


final modeProvider = StateNotifierProvider.autoDispose<ModeProvider, AutovalidateMode>((ref) => ModeProvider(AutovalidateMode.disabled));


class ModeProvider extends StateNotifier<AutovalidateMode>{
  ModeProvider(super.state);

    void changeMode(){
        state = AutovalidateMode.onUserInteraction;
    }


}


final imageProvider = StateNotifierProvider.autoDispose<ImageProvider, XFile?>((ref) => ImageProvider(null));


class ImageProvider extends StateNotifier<XFile?>{
  ImageProvider(super.state);

  Future<void> pickAnImage(bool isCamera) async{
    final ImagePicker picker = ImagePicker();
     if(isCamera){
         state = await picker.pickImage(source: ImageSource.camera);
     }else{
       state = await picker.pickImage(source: ImageSource.gallery);
     }
  }


}