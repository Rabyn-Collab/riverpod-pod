import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pod/model/user.dart';

part 'common_state.freezed.dart';

@freezed
class CommonState with _$CommonState{

const factory CommonState({
  required String errText,
  required bool isLoad,
  required bool isSuccess,
  required bool isError,
  required User? user
}) =_CommonState;





}