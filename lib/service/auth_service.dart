

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pod/exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService{


  static final auth = FirebaseAuth.instance;
  static final userDb = FirebaseFirestore.instance.collection('users');

  static Future<Either<String, bool>> userLogin({
    required String email,
    required String password
}) async {
    try {
      final response = await auth.signInWithEmailAndPassword(email: email, password: password);
      return Right(true);
    } on FirebaseAuthException catch (err) {
     return Left(err.message!);
    }
  }



  static Future<Either<String, bool>> userSignUp({
    required String email,
    required String password,
    required String username,
    required XFile image
  }) async {
    try {
      final imageId = DateTime.now().toString();
      final ref = FirebaseStorage.instance.ref().child('userImage/$imageId');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      final  response = await auth.createUserWithEmailAndPassword(email: email, password: password);
    await userDb.add({
      'username': username,
      'email': email,
      'userId': response.user!.uid,
      'imageId': imageId,
      'imageUrl': url
    });
      return Right(true);
    } on DioException catch (err) {
      print(err);
      return Left(DioExceptionError.fromDioError(err));
    }
  }





}