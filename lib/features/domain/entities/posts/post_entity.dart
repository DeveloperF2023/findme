import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String? postId;
  final String? creatorUID;
  final String? username;
  final String? description;
  final String? postImageUrl;
  final List<String>? likes;
  final num? totalLikes;
  final num? totalComments;
  final Timestamp? createdAt;
  final String? userProfileUrl;

  const PostEntity(
      {
       this.postId,
       this.creatorUID,
       this.username,
       this.description,
       this.postImageUrl,
       this.likes,
       this.totalLikes,
       this.totalComments,
       this.createdAt,
       this.userProfileUrl
      });

  @override
  // TODO: implement props
  List<Object?> get props => [
    postId,
    createdAt,
    creatorUID,
    description,
    postImageUrl,
    likes,
    totalLikes,
    totalComments,
    userProfileUrl,
    username,
  ];
}
