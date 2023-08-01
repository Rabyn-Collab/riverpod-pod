import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';





final modeProvider = StateNotifierProvider.autoDispose<ModeProvider, AutovalidateMode>((ref) => ModeProvider(AutovalidateMode.disabled));


class ModeProvider extends StateNotifier<AutovalidateMode>{
  ModeProvider(super.state);

    void changeMode(){
        state = AutovalidateMode.onUserInteraction;
    }


}