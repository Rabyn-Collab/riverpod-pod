import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/model/common_state.dart';
import 'package:pod/service/auth_service.dart';




final authProvider = StateNotifierProvider<AuthProvider, CommonState>((ref) => AuthProvider(CommonState.empty()));


class AuthProvider extends StateNotifier<CommonState>{
  AuthProvider(super.state);


   Future<void> userLogin({
    required String email,
    required String password
  }) async {
     state = state.copyWith(errText: '', isError: false, isLoad: true,isSuccess: false);
     final response = await AuthService.userLogin(email: email, password: password);
     response.fold(
             (l) {
             state=  state.copyWith(errText: l, isError: true, isLoad: false,isSuccess: false);
             },
             (r) {
              state = state.copyWith(errText: '', isError: false, isLoad: false,isSuccess: r);
             }
     );

   }

}