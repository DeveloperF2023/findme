import 'dart:io';

import 'package:equatable/equatable.dart';

class UserEntity  extends Equatable{
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
  ///will not going to store in database
  final File? imageFile;
  final String? password;
  final String? otherUid;

  const UserEntity(
      {
        this.imageFile,
        this.uid,
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
      this.password,
      this.otherUid,
      this.totalPost
      });

  @override
  // TODO: implement props
  List<Object?> get props => [
    uid,
    name,
    username,
    biography,
    website,
    email,
    profileUrl,
    followers,
    following,
    totalFollowers,
    totalFollowing,
    password,
    otherUid,
    totalPost,
    imageFile
  ];
}
