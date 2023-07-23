









import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/api.dart';
import 'package:pod/model/movie.dart';
import 'package:pod/model/video.dart';

import '../constants/token.dart';



final videoProvider = FutureProvider.family((ref, int id) => MovieService.getMovieVideo(id));


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
           HttpHeaders.authorizationHeader: token
         },

       ));
       final data = (response.data['results'] as List).map((e) => Movie.fromJson(e)).toList();
      return Right(data);
     } on DioException catch(err){
     return Left(err.response.toString());
     }
  }



  static Future<List<Video>> getMovieVideo(int id) async{
    try{
      final response = await dio.get('${Api.baseUrl}/movie/$id/videos',
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader: token
            },

          ));
      final data = (response.data['results'] as List).map((e) => Video.fromJson(e)).toList();
      return data;
    } on DioException catch(err){
      throw   err.response.toString();
    }
  }










}