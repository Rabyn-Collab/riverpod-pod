import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_state.freezed.dart';

@freezed
class CommonState with _$CommonState{

const factory CommonState({
  required String errText,
  required bool isLoad,
  required bool isSuccess,
  required bool isError,
}) =_CommonState;


factory CommonState.empty(){
  return CommonState(errText: '', isLoad: false, isSuccess: false, isError: false);
}



}