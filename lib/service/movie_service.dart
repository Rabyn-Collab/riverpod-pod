









import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pod/model/movie.dart';

class MovieService{

  static final dio = Dio();



 static Future<Either<String, List<Movie>>> getMovieByCategory(String apiPath, int page) async{
     try{
       final response = await dio.get(apiPath,
           queryParameters: {
            'page': page
           },
           options: Options(
         headers: {
           HttpHeaders.authorizationHeader: 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYTBmOTI2OTYxZDAwYzY2N2UxOTFhMjFjMTQ0NjFmOCIsInN1YiI6IjYwNDYxNTM0MzVhNjFlMDA1YjdjMmZmYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.LvbdGQ5pvkEgSZY4JkNVIY3g-qF8PRygp7FnacsO1R0'
         },

       ));
       final data = (response.data['results'] as List).map((e) => Movie.fromJson(e)).toList();
      return Right(data);
     } on DioException catch(err){
     return Left(err.response.toString());
     }
  }












}