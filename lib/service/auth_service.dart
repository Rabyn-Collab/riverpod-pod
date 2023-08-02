





import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pod/api.dart';
import 'package:pod/exception.dart';

class AuthService{


  static final dio = Dio();

  static Future<Either<String, bool>> userLogin({
    required String email,
    required String password
}) async {
    try {
      final response = await dio.get(Api.userLogin,
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
      return Right(true);
    } on DioException catch (err) {
      print(err);
     return Left(DioExceptionError.fromDioError(err));
    }
  }


}