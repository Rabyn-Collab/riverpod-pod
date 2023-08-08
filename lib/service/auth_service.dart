





import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pod/api.dart';
import 'package:pod/exception.dart';
import 'package:pod/model/user.dart';

class AuthService{


  static final dio = Dio();

  static Future<Either<String, User>> userLogin({
    required String email,
    required String password
}) async {
    try {
      final response = await dio.post(Api.userLogin,
          data: {
           'email': email,
            'password': password
          },
          options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }
      ));
      final user = Hive.box<String?>('user');
     user.put('userInfo', jsonEncode(response.data));
      return Right(User.fromJson(response.data));
    } on DioException catch (err) {
      print(err);
     return Left(DioExceptionError.fromDioError(err));
    }
  }



  static Future<Either<String, bool>> userSignUp({
    required String email,
    required String password,
    required String fullname
  }) async {
    try {
      final response = await dio.post(Api.userSignUp,
          data: {
            'email': email,
            'password': password,
            'fullname': fullname
          },
          options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
              }
          ));
      return Right(true);
    } on DioException catch (err) {
      print(err);
      return Left(DioExceptionError.fromDioError(err));
    }
  }

}