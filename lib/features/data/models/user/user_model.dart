import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel extends UserEntity {
  final String? uid;
  final String? name;
  final String? username;
  final String? biography;
  final String? website;
  final String? email;
  final String? profileUrl;
  final List? followers;
  final List? following;
  final num? totalFollowers;
  final num? totalFollowing;
  final num? totalPost;

  const UserModel(
      {this.uid,
      this.name,
      this.username,
      this.biography,
      this.website,
      this.email,
      this.profileUrl,
      this.followers,
      this.following,
      this.totalFollowers,
      this.totalFollowing,
      this.totalPost
      })
      : super(
            uid: uid,
            totalFollowers: totalFollowers,
            totalFollowing: totalFollowing,
            totalPost: totalPost,
            name: name,
            username: username,
            biography: biography,
            website: website,
            email: email,
            profileUrl: profileUrl,
            following: following,
            followers: followers);

  factory UserModel.fromSnapshot(DocumentSnapshot snap){
   var snapshot = snap.data() as Map<String,dynamic>;

   return UserModel(
     email: snapshot['email'],
     name: snapshot['name'],
     username: snapshot['username'],
     biography: snapshot['biography'],
     totalFollowing: snapshot['totalFollowing'],
     totalFollowers: snapshot['totalFollowers'],
     website: snapshot['website'],
     profileUrl: snapshot['profileUrl'],
     followers: List.from(snap.get('followers')),
     following: List.from(snap.get('following')),
     uid: snapshot['uid'],
     totalPost: snapshot['totalPost']
   );
  }
  Map<String,dynamic> toJson()=>{
    "email":email,
    "name":name,
    "username":username,
    "biography":biography,
    "totalFollowing":totalFollowing,
    "totalFollowers":totalFollowers,
    "website":website,
    "profileUrl":profileUrl,
    "uid":uid,
    "totalPost":totalPost,
    "followers":followers,
    "following":following
  };

}
