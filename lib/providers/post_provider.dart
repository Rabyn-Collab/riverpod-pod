import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pod/model/common_state.dart';
import 'package:pod/model/post.dart';
import 'package:pod/service/post_service.dart';




final postProvider = StateNotifierProvider<PostProvider, CommonState>((ref) => PostProvider(CommonState(
    errText: '', isLoad: false, isSuccess: false, isError: false)));


class PostProvider extends StateNotifier<CommonState>{
  PostProvider(super.state);


   Future<void> addPost({
     required String detail,
    required String title,
    required String userId,
    required XFile image
  }) async{
     state = state.copyWith(errText: '', isError: false, isLoad: true,isSuccess: false);
     final response = await PostService.addPost(detail: detail, title: title, userId: userId, image: image);
     response.fold(
             (l) {
           state=  state.copyWith(errText: l, isError: true, isLoad: false,isSuccess: false);
         },
             (r) {
           state = state.copyWith(errText: '', isError: false, isLoad: false,isSuccess: r);
         }
     );
   }


   Future<void> updatePost({
    required String detail,
    required String title,
    required String postId,
    XFile? image,
    String? oldImageId,
  }) async{
    state = state.copyWith(errText: '', isError: false, isLoad: true,isSuccess: false);
    final response = await PostService.updatePost(detail: detail, title: title, postId: postId,oldImageId: oldImageId, image: image);
    response.fold(
            (l) {
          state=  state.copyWith(errText: l, isError: true, isLoad: false,isSuccess: false);
        },
            (r) {
          state = state.copyWith(errText: '', isError: false, isLoad: false,isSuccess: r);
        }
    );
  }



  Future<void> removePost({
    required String postId,
    required String imageId
  }) async{
    state = state.copyWith(errText: '', isError: false, isLoad: true,isSuccess: false);
    final response = await PostService.removePost(postId: postId, imageId: imageId);
    response.fold(
            (l) {
          state=  state.copyWith(errText: l, isError: true, isLoad: false,isSuccess: false);
        },
            (r) {
          state = state.copyWith(errText: '', isError: false, isLoad: false,isSuccess: r);
        }
    );
  }


   Future<void> commentPost({
    required Comment comment,
    required String postId
  }) async{
     state = state.copyWith(errText: '', isError: false, isLoad: true,isSuccess: false);
     final response = await PostService.commentPost(comment: comment, postId: postId);
     response.fold(
             (l) {
           state=  state.copyWith(errText: l, isError: true, isLoad: false,isSuccess: false);
         },
             (r) {
           state = state.copyWith(errText: '', isError: false, isLoad: false,isSuccess: r);
         }
     );
  }


   Future<void> likePost({
    required String username,
    required int oldLike,
    required String postId
  }) async{
     state = state.copyWith(errText: '', isError: false, isLoad: true,isSuccess: false);
     final response = await PostService.likePost(username: username, oldLike: oldLike, postId: postId);
     response.fold(
             (l) {
           state=  state.copyWith(errText: l, isError: true, isLoad: false,isSuccess: false);
         },
             (r) {
           state = state.copyWith(errText: '', isError: false, isLoad: false,isSuccess: r);
         }
     );
  }


}