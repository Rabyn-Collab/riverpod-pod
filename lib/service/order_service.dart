import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pod/api.dart';
import 'package:pod/exception.dart';
import 'package:pod/model/cart_item.dart';
import 'package:pod/model/orders.dart';





final orderDataProvider = FutureProvider.family((ref, String token) => OrderService.getOrderByUser(token));



class OrderService {
  static final dio = Dio();

  static Future<List<Orders>>  getOrderByUser(String token) async {
    try {
      final response = await dio.get(Api.getOrderByUser, options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': token
          }
      ));
      return (response.data as List).map((e) => Orders.fromJson(e)).toList();
    } on DioException catch (err) {
      throw DioExceptionError.fromDioError(err);
    }
  }

  static Future<Either<String, bool>>  addOrder ({
   required List<CartItem> orderItems,
   required int totalPrice,
    required String token
  })async {
    try {

      final response = await dio.post(Api.orderAdd, data: {
        'orderItems': orderItems.map((e) => e.toJson()).toList(),
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
