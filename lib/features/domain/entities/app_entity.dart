
import 'package:social/features/domain/entities/comments/comment_entity.dart';
import 'package:social/features/domain/entities/posts/post_entity.dart';
import 'package:social/features/domain/entities/user/user_entity.dart';

class AppEntity{
  final UserEntity? currentUser;
  final PostEntity? postEntity;
  final CommentEntity? comment;
  final String uid;
  final String? postId;

  AppEntity({ this.currentUser,  this.postEntity,  required this.uid,  this.postId,this.comment});
}