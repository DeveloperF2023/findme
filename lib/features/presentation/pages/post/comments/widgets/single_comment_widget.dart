import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:social/features/domain/entities/replay/replay_entity.dart';
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:social/features/presentation/cubit/reply/replay_cubit.dart';
import 'package:social/features/presentation/pages/post/comments/widgets/single_replay_widget.dart';
import 'package:social/injection_container.dart' as injection;
import 'package:social/features/presentation/pages/post/comments/widgets/text_field_reply.dart';
import 'package:uuid/uuid.dart';
import '../../../../../../constants.dart';
import '../../../../../domain/entities/comments/comment_entity.dart';
import '../../../profile/widgets/profile_widget.dart';

class SingleCommentWidget extends StatefulWidget {
  const SingleCommentWidget(
      {super.key,
      required this.comment,
      this.onLongPressListener,
      this.onLikeClickListener,
      required this.currentUser});
  final CommentEntity comment;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;
  final UserEntity currentUser;
  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  TextEditingController replyController = TextEditingController();
  bool isUserReplying = false;
  bool isText = false;
  bool isMaxLines = false;
  String _currentUid = "";
  bool _isCurrenuUser = false;
  @override
  void initState() {
    super.initState();
    injection.serviceLocator<GetCurrentUIDUseCase>().callback().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    BlocProvider.of<ReplayCubit>(context).getReplays(
        replay: ReplayEntity(
          postId: widget.comment.postId,
          commentId: widget.comment.commentId,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress:widget.comment.creatorUID == _currentUid ? widget.onLongPressListener:null,
      //onLongPress: widget.onLongPressListener,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 35,
              height: 35,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child:
                    profileWidget(imageUrl: "${widget.comment.userProfileUrl}"),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .63,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${widget.comment.username}",
                              style: const TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: black87)),
                          Text(
                              DateFormat.jm()
                                  .format(widget.comment.createdAt!.toDate()),
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: grey400)),
                        ],
                      ),
                    ],
                  ),
                  sizeVertical(5),

                  ///comment text
                  Text("${widget.comment.description}",
                      style: const TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54)),
                  sizeVertical(10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isUserReplying = !isUserReplying;
                          });
                        },
                        child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: primary.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(5)),
                            child: const Center(
                              child: Icon(
                                EvaIcons.undo,
                                color: primary,
                                size: 16,
                              ),
                            )),
                      ),
                      sizeHorizontal(10),

                      ///view replies button
                      GestureDetector(
                        onTap: () {
                          _getReplays();
                        },
                        child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: primary.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(5)),
                            child: const Center(
                              child: Icon(
                                EvaIcons.eye,
                                color: primary,
                                size: 16,
                              ),
                            )),
                      ),
                    ],
                  ),
                  BlocBuilder<ReplayCubit, ReplayState>(
                    builder: (context, replayState) {
                      if (replayState is ReplayLoaded) {
                        final replays = replayState.replays.where((element) => element.commentId == widget.comment.commentId).toList();
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: replays.length,
                            itemBuilder: (context, index) {
                              return SingleReplayWidget(
                                replay: replays[index],
                                onLongPressListener: (){
                                  onLongBottomSheet(context: context, replay: replayState.replays[index]);
                                },
                                onLikeClickListener: (){
                                  likeReplay(replay: replays[index]);
                                },
                              );
                            });
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                  isUserReplying == true ? sizeVertical(10) : sizeVertical(0),
                  isUserReplying == true
                      ? Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width * .5,
                              child: FormContainerReply(
                                fillColor:
                                    const Color(0xffF8F9F9).withOpacity(0.7),
                                controller: replyController,
                                maxLines: null,
                                hintText: "Your reply",
                              ),
                            ),
                            sizeHorizontal(5),
                            GestureDetector(
                              onTap: () {
                                _createReplay();
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * .05,
                                width: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: primary),
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
                        )
                      : const SizedBox(
                          width: 0,
                          height: 0,
                        )
                ],
              ),
            ),
            SizedBox(
              width: 38,
              height: 50,
              child: Center(
                child: IconButton(
                    onPressed: widget.onLikeClickListener,
                    icon: Icon(
                      widget.comment.likes!.contains(_currentUid)
                          ? EvaIcons.heart
                          : EvaIcons.heartOutline,
                      color: widget.comment.likes!.contains(_currentUid)
                          ? Colors.red
                          : black87,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  _createReplay() {
    BlocProvider.of<ReplayCubit>(context)
        .createReplay(
            replay: ReplayEntity(
                replayId: const Uuid().v1(),
                createdAt: Timestamp.now(),
                likes: const [],
                username: widget.comment.username,
                userProfileUrl: widget.currentUser.profileUrl,
                creatorUID: widget.currentUser.uid,
                postId: widget.comment.postId,
                commentId: widget.comment.commentId,
                description: replyController.text))
        .then((value) {
      setState(() {
        replyController.clear();
        isUserReplying = false;
      });
    });
  }

  _getReplays() {
    widget.comment.totalReplays != 0 ?
    BlocProvider.of<ReplayCubit>(context).getReplays(
        replay: ReplayEntity(
      postId: widget.comment.postId,
      commentId: widget.comment.commentId,
    )):Fluttertoast.showToast(msg: "no replays");
  }
  onLongBottomSheet(
      {required BuildContext context, required ReplayEntity replay}) {
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
                          deleteReplay(replay: replay);
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
                          updateBottomSheet(replay: replay);
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

  deleteReplay({required ReplayEntity replay}) {
    BlocProvider.of<ReplayCubit>(context)
        .deleteReplay(
        replay: ReplayEntity(
          commentId: replay.commentId,
          postId: replay.postId,
          replayId: replay.replayId
        ))
        .then((value) {
      setState(() {
        Navigator.pop(context);
      });
    });
  }
  updateMainWidget({required ReplayEntity replay}) {
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
                      profileWidget(imageUrl: "${replay.userProfileUrl}"),
                    ),
                  ),
                  sizeHorizontal(10),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .7,
                    child: FormContainerReply(
                      fillColor: Colors.transparent,
                      controller: replyController,
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
                  updateReplay(replay: replay);
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
  updateBottomSheet({required ReplayEntity replay}) {
    replyController = TextEditingController(text: replay.description);
    return showModalBottomSheet(
        backgroundColor: backgroundColor,
        context: context,
        builder: (context) {
          return BlocProvider<ReplayCubit>(
            create: (context) => injection.serviceLocator<ReplayCubit>(),
            child: updateMainWidget(replay: replay),
          );
        });
  }
  updateReplay({required ReplayEntity replay}) {
    BlocProvider.of<ReplayCubit>(context)
        .updateReplay(
        replay: ReplayEntity(
            postId: replay.postId,
            replayId: replay.replayId,
            commentId: replay.commentId,
            description: replyController.text))
        .then((value) {
      setState(() {
        replyController.clear();
        Navigator.pop(context);
      });
    });
  }
  likeReplay({required ReplayEntity replay}) {
    BlocProvider.of<ReplayCubit>(context).likeReplay(
        replay: ReplayEntity(
          commentId: replay.commentId,
          postId: replay.postId,
          replayId: replay.replayId
        ));
  }

}
