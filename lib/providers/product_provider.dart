import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pod/model/common_state.dart';
import 'package:pod/service/product_service.dart';




final productProvider = StateNotifierProvider<ProductProvider, CommonState>((ref) => ProductProvider(CommonState(
    errText: '', isLoad: false, isSuccess: false, isError: false, user: null)));


class ProductProvider extends StateNotifier<CommonState>{
  ProductProvider(super.state);



   Future<void>  addProduct ({
    required String product_name,
    required String product_detail,
    required int   product_price,
    required XFile product_image,
    required String brand,
    required String category,
    required int countInStock,
    required String token
  })async {
    state = state.copyWith(errText: '', isError: false, isLoad: true,isSuccess: false);
    final response = await ProductService.addProduct(
        product_name: product_name, product_detail: product_detail,
        product_price: product_price, product_image: product_image, brand: brand,
        category: category, countInStock: countInStock, token: token);
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