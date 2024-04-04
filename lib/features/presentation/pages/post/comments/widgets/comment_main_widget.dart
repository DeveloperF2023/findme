import 'dart:ui';
import 'package:social/features/presentation/cubit/reply/replay_cubit.dart';
import 'package:social/injection_container.dart' as injection;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/domain/entities/app_entity.dart';
import 'package:social/features/presentation/pages/main_screen/main_screen.dart';
import 'package:social/features/presentation/pages/post/comments/widgets/single_comment_widget.dart';
import 'package:social/features/presentation/pages/post/comments/widgets/text_field_reply.dart';
import 'package:uuid/uuid.dart';
import '../../../../../../constants.dart';
import '../../../../../domain/entities/comments/comment_entity.dart';
import '../../../../../domain/entities/user/user_entity.dart';
import '../../../../cubit/comment/comment_cubit.dart';
import '../../../../cubit/get_single_post/get_single_post_cubit.dart';
import '../../../../cubit/user/get_single_user/get_single_user_cubit.dart';
import '../../../profile/widgets/profile_widget.dart';

class CommentMainWidget extends StatefulWidget {
  const CommentMainWidget({super.key, required this.appEntity});
  final AppEntity appEntity;
  @override
  State<CommentMainWidget> createState() => _CommentMainWidgetState();
}

class _CommentMainWidgetState extends State<CommentMainWidget> {
  TextEditingController replyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TextEditingController _updateController = TextEditingController();
  bool isUserReplying = false;
  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.appEntity.uid);
   // BlocProvider.of<GetSinglePostCubit>(context).getSinglePost(postId: widget.appEntity.postId!);
    BlocProvider.of<CommentCubit>(context)
        .getComments(postId: widget.appEntity.postId!);

    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _updateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MainScreen(uid: widget.appEntity.uid)));
            },
          ),
        ),
        body: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
          builder: (context, singleUserState) {
            if (singleUserState is GetSingleUserLoaded) {
              final singleUser = singleUserState.user;
              return BlocBuilder<CommentCubit, CommentState>(
                builder: (context, commentState) {
                  if (commentState is CommentLoaded) {
                    return SafeArea(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: ListView.separated(
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          Divider(
                                            thickness: 4,
                                            indent: 1,
                                            endIndent: 2,
                                            color: grey200!.withOpacity(0.3),
                                          ),
                                  shrinkWrap: true,
                                  itemCount: commentState.comments.length,
                                  itemBuilder: (context, index) {
                                    final singleComment = commentState.comments[index];
                                    return BlocProvider(
                                      create: (context) => injection.serviceLocator<ReplayCubit>(),
                                      child: SingleCommentWidget(
                                        currentUser: singleUser,
                                        comment: singleComment,
                                        onLongPressListener: () {
                                          onLongBottomSheet(
                                              context: context,
                                              comment:
                                                  commentState.comments[index]);
                                        },
                                        onLikeClickListener: () {
                                          likeComment(
                                              comment:
                                                  commentState.comments[index]);
                                        },
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          commentSection(currentUser: singleUser),
                        ],
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  commentSection({required UserEntity currentUser}) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .06,
          width: MediaQuery.of(context).size.width * .9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .06,
                width: MediaQuery.of(context).size.width * .8,
                child: FormContainerReply(
                  fillColor: Colors.white,
                  controller: _descriptionController,
                  hintText: "Your comment",
                ),
              ),
              GestureDetector(
                onTap: () {
                  createComment(currentUser);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * .06,
                  width: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), color: primary),
                  child: const Center(
                    child: Icon(
                      EvaIcons.navigationOutline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  createComment(UserEntity currentUser) {
    BlocProvider.of<CommentCubit>(context)
        .createComment(
            comment: CommentEntity(
                totalReplays: 0,
                commentId: const Uuid().v1(),
                createdAt: Timestamp.now(),
                likes: const [],
                username: currentUser.username,
                userProfileUrl: currentUser.profileUrl,
                description: _descriptionController.text,
                creatorUID: currentUser.uid,
                postId: widget.appEntity.postId))
        .then((value) {
      setState(() {
        _descriptionController.clear();
      });
    });
  }

  onLongBottomSheet(
      {required BuildContext context, required CommentEntity comment}) {
    return showModalBottomSheet(
        backgroundColor: grey200,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * .16,
            decoration: BoxDecoration(
              color: grey200,
            ),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "More Options",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87),
                      ),
                    ),
                    sizeVertical(10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          deleteComment(
                              commentId: comment.commentId!,
                              postId: comment.postId!);
                        },
                        child: Row(
                          children: [
                            const Icon(
                              EvaIcons.trash2Outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            sizeHorizontal(15),
                            const Text(
                              "Delete Comment",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: black87),
                            ),
                          ],
                        ),
                      ),
                    ),
                    sizeVertical(15),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          updateBottomSheet(comment: comment);
                        },
                        child: Row(
                          children: [
                            const Icon(
                              EvaIcons.editOutline,
                              color: Colors.green,
                              size: 20,
                            ),
                            sizeHorizontal(15),
                            const Text(
                              "Update Comment",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: black87),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  deleteComment({required String commentId, required String postId}) {
    BlocProvider.of<CommentCubit>(context)
        .deleteComment(
            comment: CommentEntity(
      commentId: commentId,
      postId: postId,
    ))
        .then((value) {
      setState(() {
        Navigator.pop(context);
      });
    });
  }

  likeComment({required CommentEntity comment}) {
    BlocProvider.of<CommentCubit>(context).likeComment(
        comment: CommentEntity(
      commentId: comment.commentId,
      postId: comment.postId,
    ));
  }

  updateBottomSheet({required CommentEntity comment}) {
    _updateController = TextEditingController(text: comment.description);
    return showModalBottomSheet(
        backgroundColor: backgroundColor,
        context: context,
        builder: (context) {
          return BlocProvider<CommentCubit>(
            create: (context) => injection.serviceLocator<CommentCubit>(),
            child: updateMainWidget(comment: comment),
          );
        });
  }

  updateMainWidget({required CommentEntity comment}) {
    return Container(
      height: (MediaQuery.of(context).viewInsets.bottom != 0)
          ? MediaQuery.of(context).size.height * .36
          : MediaQuery.of(context).size.height * .20,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child:
                          profileWidget(imageUrl: "${comment.userProfileUrl}"),
                    ),
                  ),
                  sizeHorizontal(10),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .7,
                    child: FormContainerReply(
                      controller: _updateController,
                    ),
                  )
                ],
              ),
            ),
            sizeVertical(10),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * .73),
              child: GestureDetector(
                onTap: () {
                  updateComment(comment: comment);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * .05,
                  width: MediaQuery.of(context).size.width * .15,
                  decoration: BoxDecoration(
                      color: primary, borderRadius: BorderRadius.circular(5)),
                  child: const Icon(
                    EvaIcons.edit2,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  updateComment({required CommentEntity comment}) {
    BlocProvider.of<CommentCubit>(context)
        .updateComment(
            comment: CommentEntity(
                postId: comment.postId,
                commentId: comment.commentId,
                description: _updateController.text))
        .then((value) {
      setState(() {
        _updateController.clear();
        Navigator.pop(context);
      });
    });
  }
}
