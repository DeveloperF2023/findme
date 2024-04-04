
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReplayEntity extends Equatable{
  final String? creatorUID;
  final String? replayId;
  final String? commentId;
  final String? postId;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final List<String>? likes;
  final Timestamp? createdAt;

  const ReplayEntity(
      {this.creatorUID,
      this.replayId,
      this.commentId,
      this.postId,
      this.description,
      this.username,
      this.userProfileUrl,
      this.likes,
      this.createdAt});

  @override
  // TODO: implement props
  List<Object?> get props => [
    creatorUID,
    replayId,
    commentId,
    postId,
    description,
    username,
    userProfileUrl,
    likes,
    createdAt
  ];

}