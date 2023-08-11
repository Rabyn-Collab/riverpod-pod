import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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

  static Future<Either<String, bool>>  addProduct ({
   required String product_name,
   required String product_detail,
    required int   product_price,
    required XFile product_image,
    required String brand,
    required String category,
    required int countInStock,
    required String token
   })async {
    try {
      final formData = FormData.fromMap({
        'product_name': product_name,
        'product_detail': product_detail,
        'product_price': product_price,
         'brand': brand,
         'category' : category,
          'countInStock': countInStock,
        'product_image':  await MultipartFile.fromFile(product_image.path, filename: product_image.name),
      });
      final response = await dio.post(Api.addProduct, data: formData, options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            HttpHeaders.authorizationHeader: token,
          }
      ));
      return Right(true);
    } on DioException catch (err) {
     return Left(DioExceptionError.fromDioError(err));
    }
  }







}
