import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pod/api.dart';
import 'package:pod/exception.dart';
import 'package:pod/model/orders.dart';
import 'package:pod/model/product.dart';




final productProvider = FutureProvider((ref) => ProductService.getAllProducts);



class ProductService {
  static final dio = Dio();

  static Future<List<Orders>>  getOrderById() async {
    try {
      final response = await dio.get(Api.baseUrl, options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }
      ));
      return (response.data as List).map((e) => Orders.fromJson(e)).toList();
    } on DioException catch (err) {
      print(err);
      throw DioExceptionError.fromDioError(err);
    }
  }

  static Future<Either<String, bool>>  addOrder ({
   required List<Orders> orderItems,
   required int totalPrice,
    required String token
  })async {
    try {

      final response = await dio.post(Api.addProduct, data: {
        'orderItems': orderItems,
        'totalPrice': totalPrice
      }, options: Options(
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
