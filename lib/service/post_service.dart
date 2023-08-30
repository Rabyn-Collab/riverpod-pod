import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pod/model/post.dart';






final postsStream = StreamProvider((ref) => PostService.postsStream());
final postStream=  StreamProvider.family((ref, String postId) =>PostService.postStream(postId));
class PostService{



  static final postDb = FirebaseFirestore.instance.collection('posts');



  static Stream<Post> postStream (String postId){
    return postDb.doc(postId).snapshots().map((e) {
      final json = e.data() as Map<String, dynamic>;
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
    }
    );
  }




  static Stream<List<Post>> postsStream (){

    return postDb.snapshots().map((event) => event.docs.map((e) {
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
    }).toList());
    }




  static Future<Either<String, bool>> addPost({
   required String detail,
    required String title,
  required String userId,
  required XFile image
  }) async{
       try{
         final imageId = DateTime.now().toString();
         final ref = FirebaseStorage.instance.ref().child('postImage/$imageId');
         await ref.putFile(File(image.path));
         final url = await ref.getDownloadURL();

         final response = await postDb.add({
           'detail': detail,
           'imageId': imageId,
           'imageUrl': url,
           'title': title,
           'userId': userId,
           'comments': [],
           'like': {
             'likes': 0,
             'users': []
           }
         });
         return Right(true);
       }on FirebaseException catch (err){
         return Left(err.message.toString());
       }

  }


  static Future<Either<String, bool>> updatePost({
    required String detail,
    required String title,
    required String postId,
     XFile? image,
     String? oldImageId,
  }) async{
    try{

      if(image == null){
        await postDb.doc(postId).update({
          'title': title,
          'detail': detail
        });
      }else {

        final ref = FirebaseStorage.instance.ref().child('postImage/$oldImageId');
        await ref.delete();

        final imageId = DateTime.now().toString();
        final ref1 = FirebaseStorage.instance.ref().child('postImage/$imageId');
        await ref1.putFile(File(image.path));
        final url = await ref1.getDownloadURL();

        final response = await postDb.doc(postId).update({
          'detail': detail,
          'imageId': imageId,
          'imageUrl': url,
          'title': title,
        });
      }
      return Right(true);
    }on FirebaseException catch (err){
      return Left(err.message.toString());
    }

  }




  static Future<Either<String, bool>> removePost({
    required String postId,
    required String imageId
  }) async{
    try{
      final ref = FirebaseStorage.instance.ref().child('postImage/$imageId');
      await ref.delete();
      await postDb.doc(postId).delete();
      return Right(true);
    }on FirebaseException catch (err){
      return Left(err.message.toString());
    }

  }


  static Future<Either<String, bool>> commentPost({
    required Comment comment,
    required String postId
  }) async{
    try{

      await postDb.doc(postId).update({
        'comments': FieldValue.arrayUnion([comment.toMap()]),
      });
      return Right(true);
    }on FirebaseException catch (err){
      return Left(err.message.toString());
    }

  }


  static Future<Either<String, bool>> likePost({
    required String username,
    required int oldLike,
    required String postId
  }) async{
    try{

      await postDb.doc(postId).update({
        'like': {
          'likes': oldLike + 1,
          'users': FieldValue.arrayUnion([username])
        }
      });
      return Right(true);
    }on FirebaseException catch (err){
      print(err);
      return Left(err.message.toString());
    }

  }



}