









import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/api.dart';
import 'package:pod/model/movie.dart';
import 'package:pod/model/video.dart';

import '../constants/token.dart';



final videoProvider = FutureProvider.family((ref, int id) => MovieService.getMovieVideo(id));
final recommendProvider = FutureProvider.family((ref, int id) => MovieService.getRecommendMovie(id));



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
      print(response.data['results']);
      final data = (response.data['results'] as List).map((e) => Video.fromJson(e)).toList();
      return data;
    } on DioException catch(err){
      throw   err.response.toString();
    }
  }




  static Future<Either<String, List<Movie>>> searchMovie(String searchText, String apiPath) async{
    try{
      final response = await dio.get(apiPath,
          queryParameters: {
            'query': searchText,
          },
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader: token
            },

          ));
      if((response.data['results'] as List).isEmpty){
        return Left('no-data found try using another keyword');
      }else{
        final data = (response.data['results'] as List).map((e) => Movie.fromJson(e)).toList();
        return Right(data);
      }
      final data = (response.data['results'] as List).map((e) => Movie.fromJson(e)).toList();
      return Right(data);
    } on DioException catch(err){
      return Left(err.response.toString());
    }
  }


  static Future<List<Movie>> getRecommendMovie(int id) async{
    try{
      final response = await dio.get('${Api.baseUrl}/movie/$id/recommendations',
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader: token
            },

          ));
      print(response.data['results']);
      final data = (response.data['results'] as List).map((e) => Movie.fromJson(e)).toList();
      return data;
    } on DioException catch(err){
      throw   err.response.toString();
    }
  }





}