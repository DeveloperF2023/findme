

import 'dart:io';

import 'package:social/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:social/features/domain/entities/comments/comment_entity.dart';
import 'package:social/features/domain/entities/posts/post_entity.dart';
import 'package:social/features/domain/entities/replay/replay_entity.dart';
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImplementation implements FirebaseRepository{
  final FirebaseRemoteDataSource remoteDataSource;

  FirebaseRepositoryImplementation({required this.remoteDataSource});
  @override
  Future<void> createUser(UserEntity user)  async => remoteDataSource.createUser(user);

  @override
  Future<String> getCurrentUID() async => remoteDataSource.getCurrentUID();

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) => remoteDataSource.getSingleUser(uid);

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) => remoteDataSource.getUsers(user);

  @override
  Future<bool> isSignIn() async => remoteDataSource.isSignIn();

  @override
  Future<void> signInUser(UserEntity user) async=> remoteDataSource.signInUser(user);

  @override
  Future<void> signOut() async => remoteDataSource.signOut();

  @override
  Future<void> signUpUser(UserEntity user) async => remoteDataSource.signUpUser(user);

  @override
  Future<void> updateUser(UserEntity user)async => remoteDataSource.updateUser(user);

  @override
  Future<String> uploadImageToStorage(File? file, bool isPost, String childName) async =>remoteDataSource.uploadImageToStorage(file, isPost, childName);

  @override
  Future<void> createPost(PostEntity post) async => remoteDataSource.createPost(post);

  @override
  Future<void> deletePost(PostEntity post) async => remoteDataSource.deletePost(post);

  @override
  Future<void> likePost(PostEntity post) async => remoteDataSource.likePost(post);

  @override
  Stream<List<PostEntity>> readPosts(PostEntity post) => remoteDataSource.readPosts(post);

  @override
  Future<void> updatePost(PostEntity post) async => remoteDataSource.updatePost(post);

  @override
  Future<void> createComment(CommentEntity comment) async => remoteDataSource.createComment(comment);

  @override
  Future<void> deleteComment(CommentEntity comment) async =>remoteDataSource.deleteComment(comment);

  @override
  Future<void> likeComment(CommentEntity comment) async => remoteDataSource.likeComment(comment);

  @override
  Stream<List<CommentEntity>> readComments(String postId) => remoteDataSource.readComments(postId);

  @override
  Future<void> updateComment(CommentEntity comment) async => remoteDataSource.updateComment(comment);

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) => remoteDataSource.readSinglePost(postId);

  @override
  Future<void> createReplay(ReplayEntity replay) async => remoteDataSource.createReplay(replay);

  @override
  Future<void> deleteReplay(ReplayEntity replay) async => remoteDataSource.deleteReplay(replay);

  @override
  Future<void> likeReplay(ReplayEntity replay) async => remoteDataSource.likeReplay(replay);

  @override
  Stream<List<ReplayEntity>> readReplays(ReplayEntity replay) => remoteDataSource.readReplays(replay);


  @override
  Future<void> updateReplay(ReplayEntity replay) async => remoteDataSource.updateReplay(replay);
  
}