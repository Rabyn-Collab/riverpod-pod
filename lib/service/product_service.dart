import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/api.dart';
import 'package:pod/exception.dart';
import 'package:pod/model/product.dart';




final productProvider = FutureProvider((ref) => ProductService.getAllProducts);



class ProductService {
  static final dio = Dio();

  static Future<List<Product>> get getAllProducts async {
    try {
      final response = await dio.get(Api.baseUrl, options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      ));
      return (response.data as List).map((e) => Product.fromJson(e)).toList();
    } on DioException catch (err) {
      print(err);
      throw DioExceptionError.fromDioError(err);
    }
  }





}
