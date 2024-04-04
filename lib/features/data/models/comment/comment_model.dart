import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social/features/domain/entities/comments/comment_entity.dart';

class CommentModel extends CommentEntity{
  final String? commentId;
  final String? postId;
  final String? creatorUID;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createdAt;
  final List<String>? likes;
  final num? totalReplays;

  const CommentModel(
      {this.commentId,
      this.postId,
      this.creatorUID,
      this.description,
      this.username,
      this.userProfileUrl,
      this.createdAt,
      this.likes,
      this.totalReplays}):super(
      commentId: commentId,
      totalReplays: totalReplays,
      postId:postId,
      creatorUID:creatorUID,
      username:username,
      description:description,
      likes:likes,
      createdAt:createdAt,
      userProfileUrl:userProfileUrl
  );
  factory CommentModel.fromSnapshot(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;
    return CommentModel(
        postId: snapshot['postId'],
        createdAt: snapshot['createdAt'],
        creatorUID: snapshot['creatorUID'],
        userProfileUrl: snapshot['userProfileUrl'],
        username: snapshot['username'],
        description: snapshot['description'],
        likes: List.from(snap.get("likes")),
        totalReplays: snapshot['totalReplays'],
        commentId: snapshot['commentId'],
    );
  }


  Map<String,dynamic> toJson()=>{
    "postId":postId,
    "createdAt":createdAt,
    "creatorUID":creatorUID,
    "userProfileUrl":userProfileUrl,
    "username":username,
    "description":description,
    "likes":likes,
    "totalReplays":totalReplays,
    "commentId":commentId,
  };

}