import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pod/exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:pod/model/post.dart';






final userStream = StreamProvider.autoDispose((ref) => FirebaseAuth.instance.authStateChanges());
final usersStream = StreamProvider.autoDispose((ref) => FirebaseChatCore.instance.users());

final singleUserStream = StreamProvider.family((ref, String userId) => AuthService.userStream(userId));
final userPostStream = StreamProvider.family((ref, String userId) => AuthService.userPostStream(userId));



class AuthService{


  static final auth = FirebaseAuth.instance;
  static final userDb = FirebaseFirestore.instance.collection('users');


  static Stream<types.User> userStream (String userId){

    return userDb.doc(userId).snapshots().map((event) {
      final map = event.data() as Map<String, dynamic>;
      return types.User(
        id: event.id,
        metadata: map['metadata'],
        firstName: map['firstName'],
        imageUrl: map['imageUrl'],
      );
    }
    );
  }


  static Stream<List<Post>> userPostStream (String userId){

    return userDb.where('userId', isEqualTo: userId).snapshots().map((event) {
      return event.docs.map((e) {
        final json = e.data();
        return Post(
            detail: json['detail'],
            imageId: json['imageId'],
            imageUrl: json['imageUrl'],
            postId: e.id,
            title: json['title'],
            userId: json['userId'],
            comments: (json['comments'] as List).map((e) => Comment.fromJson(e)).toList(),
            like: Like.fromJson(json['like'])
        );
      }).toList();
    });
  }

  static Future<Either<String, bool>> userLogin({
    required String email,
    required String password
}) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      final response = await auth.signInWithEmailAndPassword(email: email, password: password);
      await userDb.doc(response.user!.uid).update({
        'metadata': {
          'token': token,
          'email': email
        }
      });
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
      final token = await FirebaseMessaging.instance.getToken();
      final imageId = DateTime.now().toString();
      final ref = FirebaseStorage.instance.ref().child('userImage/$imageId');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      final  response = await auth.createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: username,
          id: response.user!.uid,
          imageUrl: url,
          lastName: '',
          metadata: {
            'token': token,
            'email': email
          }
        ),
      );

      return Right(true);
    } on DioException catch (err) {
      print(err);
      return Left(DioExceptionError.fromDioError(err));
    }
  }


  static Future<Either<String, bool>> userLogOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return Right(true);
    } on DioException catch (err) {
      print(err);
      return Left(DioExceptionError.fromDioError(err));
    }
  }





}