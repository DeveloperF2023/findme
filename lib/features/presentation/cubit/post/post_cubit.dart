import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social/features/domain/entities/posts/post_entity.dart';

import '../../../domain/use_cases/firebase_usecases/post/create_post_usecase.dart';
import '../../../domain/use_cases/firebase_usecases/post/delete_post_usecase.dart';
import '../../../domain/use_cases/firebase_usecases/post/like_post_usecase.dart';
import '../../../domain/use_cases/firebase_usecases/post/read_posts_usecase.dart';
import '../../../domain/use_cases/firebase_usecases/post/update_post_usecase.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final CreatePostUseCase createPostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final LikePostUseCase likePostUseCase;
  final ReadPostUseCase readPostUseCase;
  final UpdatePostUseCase updatePostUseCase;
  PostCubit(
      {required this.createPostUseCase,
      required this.deletePostUseCase,
      required this.likePostUseCase,
      required this.readPostUseCase,
      required this.updatePostUseCase}) : super(PostInitial());

  Future<void> readPosts({required PostEntity post}) async{
    emit(PostLoading());
    try{
      final streamResponse =  readPostUseCase.callback(post);
      streamResponse.listen((posts) {
        emit(PostLoaded(posts: posts));
      });

    } on SocketException catch(_){
      emit(PostFailure());
    }catch(_){
      emit(PostFailure());
    }
  }

  Future<void> updatePost({required PostEntity post}) async{
    emit(PostLoading());
    try{
      await updatePostUseCase.callback(post);
    }
    on SocketException catch(_){
      emit(PostFailure());
    }
    catch(_){
      emit(PostFailure());
    }
  }

  Future<void> deletePost({required PostEntity post}) async{
    emit(PostLoading());
    try{
      await deletePostUseCase.callback(post);
    }
    on SocketException catch(_){
      emit(PostFailure());
    }
    catch(_){
      emit(PostFailure());
    }
  }

  Future<void> likePost({required PostEntity post}) async{
    emit(PostLoading());
    try{
      await likePostUseCase.callback(post);
    }
    on SocketException catch(_){
      emit(PostFailure());
    }
    catch(_){
      emit(PostFailure());
    }
  }

  Future<void> createPost({required PostEntity post}) async{
    emit(PostLoading());
    try{
      await createPostUseCase.callback(post);
    }
    on SocketException catch(_){
      emit(PostFailure());
    }
    catch(_){
      emit(PostFailure());
    }
  }
}
