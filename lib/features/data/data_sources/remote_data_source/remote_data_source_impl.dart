import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:social/constants.dart';
import 'package:social/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:social/features/data/models/comment/comment_model.dart';
import 'package:social/features/data/models/post/post_model.dart';
import 'package:social/features/data/models/replay/replay_model.dart';
import 'package:social/features/data/models/user/user_model.dart';
import 'package:social/features/domain/entities/comments/comment_entity.dart';
import 'package:social/features/domain/entities/posts/post_entity.dart';
import 'package:social/features/domain/entities/replay/replay_entity.dart';
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource{
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  FirebaseRemoteDataSourceImpl({required this.firebaseFirestore, required this.firebaseAuth,required this.firebaseStorage});


  Future<void> createUserWithImage(UserEntity user,String profileUrl) async{
    final uid = await getCurrentUID();
    final userCollection = firebaseFirestore.collection(FirebaseConstants.users);
    userCollection.doc(uid).get().then((userDoc){
      final newUser = UserModel(
          uid: uid,
          name: user.name,
          email: user.email,
          biography: user.biography,
          following: user.following,
          followers: user.followers,
          website: user.website,
          profileUrl: profileUrl,
          username: user.username,
          totalFollowers: user.totalFollowers,
          totalFollowing: user.totalFollowing,
          totalPost: user.totalPost
      ).toJson();
      if(!userDoc.exists){
        userCollection.doc(uid).set(newUser);
      }
      else{
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error){
      toast(message: "Some error happened",icon:EvaIcons.alertCircleOutline,color:Colors.red);
    });
  }

  @override
  Future<void> createUser(UserEntity user) async{
    final uid = await getCurrentUID();
    final userCollection = firebaseFirestore.collection(FirebaseConstants.users);
    userCollection.doc(uid).get().then((userDoc){
      final newUser = UserModel(
        uid: uid,
        name: user.name,
        email: user.email,
          biography: user.biography,
        following: user.following,
        followers: user.followers,
        website: user.website,
        profileUrl: user.profileUrl,
        username: user.username,
        totalFollowers: user.totalFollowers,
        totalFollowing: user.totalFollowing,
        totalPost: user.totalPost
      ).toJson();
      if(!userDoc.exists){
        userCollection.doc(uid).set(newUser);
      }
      else{
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error){
      toast(message: "Some error happened",icon:EvaIcons.alertCircleOutline,color:Colors.red);
    });
  }

  @override
  Future<String> getCurrentUID()async => firebaseAuth.currentUser!.uid;

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firebaseFirestore.collection(FirebaseConstants.users).where('uid',isEqualTo: uid).limit(1 );
    return userCollection.snapshots().map((querySnapShot) =>querySnapShot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    final userCollection = firebaseFirestore.collection(FirebaseConstants.users);
    return userCollection.snapshots().map((querySnapShot) =>querySnapShot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> signInUser(UserEntity user)async {
    try{
      if(user.email!.isNotEmpty || user.password!.isNotEmpty){
        await firebaseAuth.signInWithEmailAndPassword(email: user.email!, password: user.password!);
      }else{
        print("fields can not be empty");
      }
    }
   on FirebaseAuthException catch(e){
      if(e.code == "user-not-found"){
        toast(message: "user not found",icon:EvaIcons.alertCircleOutline,color:Colors.red);
      }else if(e.code == 'wrong-password'){
        toast(message: "wrong password",icon:EvaIcons.alertCircleOutline,color:Colors.red);
      }
    }
  }

  @override
  Future<void> signOut() async{
   await firebaseAuth.signOut();
  }

  @override
  Future<void> signUpUser(UserEntity user) async{
    try{
      await firebaseAuth.createUserWithEmailAndPassword(email: user.email!, password: user.password!).then((value) async{
        if(value.user?.uid != null){
          if(user.imageFile !=null){
            uploadImageToStorage(user.imageFile, false, "profileImages").then((profileUrl){
              createUserWithImage(user, profileUrl);
            });
          }
          else{
            createUserWithImage(user, '');
          }

        }
      });
      return;
    }
   on FirebaseAuthException catch(e){
      if(e.code == "email-already-in-use"){
        toast(message: "Email already in use",icon:EvaIcons.alertCircleOutline,color:Colors.red);
      }else{
        toast(message: "Something went wrong",icon:EvaIcons.alertCircleOutline,color:Colors.red);
      }
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async{
   final userCollection = firebaseFirestore.collection(FirebaseConstants.users);
   Map<String,dynamic> userInformation = {};

   if(user.username != "" && user.username != null) userInformation['username'] = user.username;
   if(user.website != "" && user.website != null) userInformation['website'] = user.website;
   if(user.profileUrl != "" && user.profileUrl != null) userInformation['profileUrl'] = user.profileUrl;
   if(user.biography != "" && user.biography != null) userInformation['bio'] = user.biography;
   if(user.name != "" && user.name != null) userInformation['name'] = user.name;
   if(user.totalFollowing != null) userInformation['totalFollowing'] = user.totalFollowing;
   if(user.totalFollowers != null) userInformation['totalFollowers'] = user.totalFollowers;
   if(user.totalPost != null) userInformation['totalPost'] = user.totalPost;

   userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Future<String> uploadImageToStorage(file, bool isPost, String childName) async{
    Reference reference = firebaseStorage.ref().child(childName).child(firebaseAuth.currentUser!.uid);
    if(isPost){
      String id = const Uuid().v1();
      reference = reference.child(id);
    }
    final uploadTask = reference.putFile(file!);
    final imageUrl = (await uploadTask.whenComplete((){})).ref.getDownloadURL();
    return await imageUrl;
  }

  @override
  Future<void> createPost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConstants.posts);
    final newPost = PostModel(
      userProfileUrl: post.userProfileUrl,
      username: post.username,
      postId: post.postId,
      creatorUID: post.creatorUID,
      createdAt: post.createdAt,
      postImageUrl: post.postImageUrl,
      totalComments: post.totalComments,
      totalLikes: post.totalLikes,
      likes: post.likes,
      description: post.description,
    ).toJson();
    try{
      final postDocReference = await postCollection.doc(post.postId).get();
      if(!postDocReference.exists){
        postCollection.doc(post.postId).set(newPost).then((value) {
          final userCollection = firebaseFirestore.collection(FirebaseConstants.users).doc(post.creatorUID);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalPosts = value.get('totalPost');
              userCollection.update({"totalPost": totalPosts + 1});
              return;
            }
          });
        });
      }else{
        postCollection.doc(post.postId).update(newPost);
      }
    }catch(e){
       print("some error occured $e");
    }
  }

  @override
  Future<void> deletePost(PostEntity post) async{
    final postCollection = firebaseFirestore.collection(FirebaseConstants.posts);
    try{
      postCollection.doc(post.postId).delete().then((value) {
        final userCollection = firebaseFirestore.collection(FirebaseConstants.users).doc(post.creatorUID);
        userCollection.get().then((value) {
          if (value.exists) {
            final totalPosts = value.get('totalPost');
            userCollection.update({"totalPost": totalPosts - 1});
            return;
          }
        });
      });
    }catch(e){
      print("some error occurred $e");
    }
  }

  @override
  Future<void> likePost(PostEntity post) async{
    final postCollection = firebaseFirestore.collection(FirebaseConstants.posts);
    final currentUID = await getCurrentUID();
    final postReference = await postCollection.doc(post.postId).get();
    if(postReference.exists){
     List likes = postReference.get('likes');
     final totalLikes = postReference.get('totalLikes');
     if(likes.contains(currentUID)){
       postCollection.doc(post.postId).update({
         "likes":FieldValue.arrayRemove([currentUID]),
         "totalLikes": totalLikes - 1
       });
     }
     else{
       postCollection.doc(post.postId).update({
         "likes":FieldValue.arrayUnion([currentUID]),
         "totalLikes": totalLikes + 1
       });
     }
    }
  }

  @override
  Stream<List<PostEntity>> readPosts(PostEntity post) {
    final postCollection = firebaseFirestore.collection(FirebaseConstants.posts).orderBy("createdAt",descending: true);
    return postCollection.snapshots().map((querySnapShot) => querySnapShot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) {
    final postCollection = firebaseFirestore.collection(FirebaseConstants.posts).orderBy("createdAt",descending: true).where('postId',isEqualTo: postId);
    return postCollection.snapshots().map((querySnapShot) => querySnapShot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updatePost(PostEntity post) async{
    final postCollection = firebaseFirestore.collection(FirebaseConstants.posts);
    Map<String,dynamic> postInformation = {};
    if(post.description != "" && post.description != null) postInformation['description'] = post.description;
    if(post.postImageUrl != "" && post.postImageUrl != null) postInformation['postImageUrl'] = post.postImageUrl;
    postCollection.doc(post.postId).update(postInformation);
  }

  @override
  Future<void> createComment(CommentEntity comment) async{
    final commentCollection = firebaseFirestore.collection(FirebaseConstants.posts).doc(comment.postId).collection(FirebaseConstants.comments);

    final newComment = CommentModel(
        userProfileUrl: comment.userProfileUrl,
        username: comment.username,
        totalReplays: comment.totalReplays,
        commentId: comment.commentId,
        postId: comment.postId,
        likes: const [],
        description: comment.description,
        creatorUID: comment.commentId,
        createdAt: comment.createdAt
    ).toJson();

    try {

      final commentDocRef = await commentCollection.doc(comment.commentId).get();

      if (!commentDocRef.exists) {
        commentCollection.doc(comment.commentId).set(newComment).then((value) {

          final postCollection = firebaseFirestore.collection(FirebaseConstants.posts).doc(comment.postId);

          postCollection.get().then((value) {
            if (value.exists) {
              final totalComments = value.get('totalComments');
              postCollection.update({"totalComments": totalComments + 1});
              return;
            }
          });
        });
      } else {
        commentCollection.doc(comment.commentId).update(newComment);
      }


    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> deleteComment(CommentEntity comment) async{
    final commentCollection = firebaseFirestore.collection(FirebaseConstants.posts).doc(comment.postId).collection(FirebaseConstants.comments);
    try{
      commentCollection.doc(comment.commentId).delete().then((value){
        final postCollection = firebaseFirestore.collection(FirebaseConstants.posts).doc(comment.postId);
        postCollection.get().then((value){
          if(value.exists){
            final totalComments = value.get("totalComments");postCollection.update({
              "totalComments":totalComments - 1
            });
            return;
          }
        });
      });
    }catch(e){
      print("some error occurred $e");
    }
  }

  @override
  Future<void> likeComment(CommentEntity comment) async{
    final commentCollection = firebaseFirestore.collection(FirebaseConstants.posts).doc(comment.postId).collection(FirebaseConstants.comments);
    final currentUID = await getCurrentUID();
    final commentReference = await commentCollection.doc(comment.commentId).get();
    if(commentReference.exists){
      List likes = commentReference.get('likes');
      if(likes.contains(currentUID)){
        commentCollection.doc(comment.commentId).update({
          "likes":FieldValue.arrayRemove([currentUID]),
        });
      }
      else{
        commentCollection.doc(comment.commentId).update({
          "likes":FieldValue.arrayUnion([currentUID]),
        });
      }
    }
  }

  @override
  Stream<List<CommentEntity>> readComments(String postId) {
    final commentCollection = firebaseFirestore.collection(FirebaseConstants.posts).doc(postId).collection(FirebaseConstants.comments).orderBy("createdAt",descending: true);
    return commentCollection.snapshots().map((querySnapShot) => querySnapShot.docs.map((e) => CommentModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore.collection(FirebaseConstants.posts).doc(comment.postId).collection(FirebaseConstants.comments);
    Map<String,dynamic> commentInformation = {};
    if(comment.description != "" && comment.description != null) commentInformation['description'] = comment.description;
    commentCollection.doc(comment.commentId).update(commentInformation);
  }

  @override
  Future<void> createReplay(ReplayEntity replay) async{
    final replayCollection = firebaseFirestore.collection(FirebaseConstants.posts).doc(replay.postId).collection(FirebaseConstants.comments).doc(replay.commentId).collection(FirebaseConstants.replay);
    final newReplay = ReplayModel(
        replayId: replay.replayId,
        userProfileUrl: replay.userProfileUrl,
        username: replay.username,
        commentId: replay.commentId,
        postId: replay.postId,
        likes: const [],
        description: replay.description,
        creatorUID: replay.creatorUID,
        createdAt: replay.createdAt
    ).toJson();
    try {

      final replayDocRef = await replayCollection.doc(replay.replayId).get();

      if (!replayDocRef.exists) {
        replayCollection.doc(replay.replayId).set(newReplay).then((value) {
          final commentCollection = firebaseFirestore.collection(FirebaseConstants.posts).doc(replay.postId).collection(FirebaseConstants.comments).doc(replay.commentId);

          commentCollection.get().then((value) {
            if (value.exists) {
              final totalReplays = value.get('totalReplays');
              commentCollection.update({"totalReplays": totalReplays + 1});
              return;
            }
          });
        });

      } else {
        replayCollection.doc(replay.replayId).update(newReplay);
      }

    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> deleteReplay(ReplayEntity replay) async{
    final replayCollection = firebaseFirestore.collection(FirebaseConstants.posts).doc(replay.postId).collection(FirebaseConstants.comments).doc(replay.commentId).collection(FirebaseConstants.replay);
    try {
      replayCollection.doc(replay.replayId).delete().then((value) {
        final commentCollection = firebaseFirestore.collection(FirebaseConstants.posts).doc(replay.postId).collection(FirebaseConstants.comments).doc(replay.commentId);

        commentCollection.get().then((value) {
          if (value.exists) {
            final totalReplays = value.get('totalReplays');
            commentCollection.update({"totalReplays": totalReplays - 1});
            return;
          }
        });
      });
    } catch(e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> likeReplay(ReplayEntity replay) async{
    final replayCollection = firebaseFirestore.collection(FirebaseConstants.posts).doc(replay.postId).collection(FirebaseConstants.comments).doc(replay.commentId).collection(FirebaseConstants.replay);
    final currentUID = await getCurrentUID();
    final replayReference = await replayCollection.doc(replay.replayId).get();

    if (replayReference.exists) {
      List likes = replayReference.get("likes");
      if (likes.contains(currentUID)) {
        replayCollection.doc(replay.replayId).update({
          "likes": FieldValue.arrayRemove([currentUID])
        });
      } else {
        replayCollection.doc(replay.replayId).update({
          "likes": FieldValue.arrayUnion([currentUID])
        });
      }
    }

  }

  @override
  Stream<List<ReplayEntity>> readReplays(ReplayEntity replay) {
    final replayCollection = firebaseFirestore.collection(FirebaseConstants.posts).doc(replay.postId).collection(FirebaseConstants.comments).doc(replay.commentId).collection(FirebaseConstants.replay);
    return replayCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => ReplayModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateReplay(ReplayEntity replay) async{
    final replayCollection = firebaseFirestore.collection(FirebaseConstants.posts).doc(replay.postId).collection(FirebaseConstants.comments).doc(replay.commentId).collection(FirebaseConstants.replay);

    Map<String, dynamic> replayInfo = Map();

    if (replay.description != "" && replay.description != null) replayInfo['description'] = replay.description;

    replayCollection.doc(replay.replayId).update(replayInfo);
  }


}