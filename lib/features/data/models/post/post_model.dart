import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social/features/domain/entities/posts/post_entity.dart';

class PostModel extends PostEntity{
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

  const PostModel(
      {this.postId,
      this.creatorUID,
      this.username,
      this.description,
      this.postImageUrl,
      this.likes,
      this.totalLikes,
      this.totalComments,
      this.createdAt,
      this.userProfileUrl}):super(
      postId:postId,
      creatorUID:creatorUID,
      username:username,
      description:description,
      postImageUrl:postImageUrl,
      likes:likes,
      totalLikes:totalLikes,
      totalComments:totalComments,
      createdAt:createdAt,
      userProfileUrl:userProfileUrl
  );
  factory PostModel.fromSnapshot(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;
    return PostModel(
      postId: snapshot['postId'],
      createdAt: snapshot['createdAt'],
      creatorUID: snapshot['creatorUID'],
      userProfileUrl: snapshot['userProfileUrl'],
      username: snapshot['username'],
      description: snapshot['description'],
      totalLikes:  snapshot['totalLikes'],
      totalComments: snapshot['totalComments'],
      postImageUrl: snapshot['postImageUrl'],
      likes: List.from(snap.get("likes"))
    );
  }

  Map<String,dynamic> toJson()=>{
    "postId":postId,
    "createdAt":createdAt,
    "creatorUID":creatorUID,
    "userProfileUrl":userProfileUrl,
    "username":username,
    "description":description,
    "totalLikes":totalLikes,
    "totalComments":totalComments,
    "postImageUrl":postImageUrl,
    "likes":likes,

  };
}