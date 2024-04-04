import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social/features/domain/entities/replay/replay_entity.dart';

class ReplayModel extends ReplayEntity{
  final String? creatorUID;
  final String? replayId;
  final String? commentId;
  final String? postId;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final List<String>? likes;
  final Timestamp? createdAt;

  const ReplayModel(
      {this.creatorUID,
      this.replayId,
      this.commentId,
      this.postId,
      this.description,
      this.username,
      this.userProfileUrl,
      this.likes,
      this.createdAt}):super(
      creatorUID:creatorUID,
      replayId:replayId,
      commentId:commentId,
      postId:postId,
      description:description,
      username:username,
      userProfileUrl:userProfileUrl,
      likes:likes,
      createdAt:createdAt
  );

  factory ReplayModel.fromSnapshot(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;
    return ReplayModel(
      creatorUID: snapshot['creatorUID'],
      replayId: snapshot['replayId'],
      commentId: snapshot['commentId'],
      postId: snapshot['postId'],
      description: snapshot['description'],
      username: snapshot['username'],
      userProfileUrl: snapshot['userProfileUrl'],
      likes: List.from(snap.get("likes")),
      createdAt: snapshot['createdAt'],
    );
  }
  Map<String,dynamic> toJson()=>{
    'creatorUID':creatorUID,
    'replayId':replayId,
    'commentId':commentId,
    'postId':postId,
    'description':description,
    'username':username,
    'userProfileUrl':userProfileUrl,
    'likes':likes,
    'createdAt':createdAt
  };
}