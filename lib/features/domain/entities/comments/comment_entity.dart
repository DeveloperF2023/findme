import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String? commentId;
  final String? postId;
  final String? creatorUID;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createdAt;
  final List<String>? likes;
  final num? totalReplays;

  const CommentEntity({
    this.commentId,
    this.postId,
    this.creatorUID,
    this.description,
    this.username,
    this.userProfileUrl,
    this.createdAt,
    this.likes,
    this.totalReplays,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    commentId,
    postId,
    creatorUID,
    description,
    username,
    userProfileUrl,
    createdAt,
    likes,
    totalReplays,
  ];
}
