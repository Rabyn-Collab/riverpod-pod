import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/model/cart_item.dart';
import 'package:pod/model/common_state.dart';
import 'package:pod/service/order_service.dart';




final orderProvider = StateNotifierProvider<OrderProvider, CommonState>((ref) => OrderProvider(CommonState(
    errText: '', isLoad: false, isSuccess: false, isError: false, user: null)));


class OrderProvider extends StateNotifier<CommonState>{
  OrderProvider(super.state);



  Future<void> ddOrder ({
    required List<CartItem> orderItems,
    required int totalPrice,
    required String token
  })async {
    state = state.copyWith(errText: '', isError: false, isLoad: true,isSuccess: false);
    final response = await OrderService.addOrder(orderItems: orderItems, totalPrice: totalPrice, token: token);
    response.fold(
            (l) {
          state=  state.copyWith(errText: l, isError: true, isLoad: false,isSuccess: false);
        },
            (r) {
          state = state.copyWith(errText: '', isError: false, isLoad: false,isSuccess: r,);
        }
    );

  }






}