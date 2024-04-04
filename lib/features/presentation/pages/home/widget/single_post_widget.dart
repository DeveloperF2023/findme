import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social/features/domain/entities/app_entity.dart';
import 'package:social/features/domain/entities/comments/comment_entity.dart';
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:social/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:social/features/presentation/cubit/post/post_cubit.dart';
import 'package:social/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:social/features/presentation/pages/post/widget/like_animation_widget.dart';
import 'package:uuid/uuid.dart';
import '../../../../../constants.dart';
import '../../../../domain/entities/posts/post_entity.dart';
import '../../post/comments/widgets/text_field_reply.dart';
import '../../post/update_post.dart';
import '../../profile/widgets/profile_widget.dart';
import '../model/more_item.dart';
import 'package:social/injection_container.dart' as injection;

class SinglePostCardWidget extends StatefulWidget {
  const SinglePostCardWidget({super.key, required this.post, required this.appEntity});
  final PostEntity post;
  final AppEntity appEntity;
  static const List<MoreItem> itemsList = [
    update,
    remove,
  ];
  static const update =
  MoreItem(text: "Update", icon: EvaIcons.edit, color: primary);
  static const remove =
  MoreItem(text: "Delete", icon: EvaIcons.trash2Outline, color: Colors.red);

  @override
  State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
}

class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {
  String _currentUid = '';
  bool _isLikeAnimating = false;
  @override
  void initState() {
    injection.serviceLocator<GetCurrentUIDUseCase>().callback().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.appEntity.uid);
    super.initState();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///header of posts
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 35,
                            height: 35,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: profileWidget(
                                  imageUrl: "${widget.post.userProfileUrl}"),
                            ),
                          ),
                          sizeHorizontal(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.post.username}",
                                style: const TextStyle(
                                    fontFamily: "Roboto",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                DateFormat("dd/MM/yyyy")
                                    .format(widget.post.createdAt!.toDate()),
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: grey400),
                              ),
                            ],
                          ),
                        ],
                      ),
                     widget.post.creatorUID == _currentUid? PopupMenuButton<MoreItem>(
                          icon: Icon(
                            EvaIcons.moreVertical,
                            color: grey400,
                          ),
                          color: Colors.white,
                          onSelected: (item) => onSelected(context, item),
                          itemBuilder: (context) => [
                            ...SinglePostCardWidget.itemsList
                                .map(buildItem)
                                .toList(),
                          ]):const SizedBox(height: 0,width: 0,),
                    ],
                  ),
                  sizeVertical(10),

                  ///post image
                  GestureDetector(
                    onDoubleTap: () {
                      _likePost();
                      setState(() {
                        _isLikeAnimating = true;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .3,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: profileWidget(
                                imageUrl: "${widget.post.postImageUrl}"),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: _isLikeAnimating ? 1 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: LikeAnimationWidget(
                              duration: const Duration(milliseconds: 300),
                              isLikeAnimating: _isLikeAnimating,
                              onLikeFinish: () {
                                setState(() {
                                  _isLikeAnimating = false;
                                });
                              },
                              child: const Icon(
                                EvaIcons.heart,
                                size: 90,
                                color: Color(0xffE74C3C),
                              )),
                        )
                      ],
                    ),
                  ),
                  sizeVertical(10),

                  ///reaction icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: _likePost,
                              icon: Icon(
                                widget.post.likes!.contains(_currentUid)
                                    ? EvaIcons.heart
                                    : EvaIcons.heartOutline,
                                size: 30,
                                color: widget.post.likes!.contains(_currentUid)
                                    ? const Color(0xffE74C3C)
                                    : black87,
                              )),
                          Text(
                            "${widget.post.totalLikes} ",
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87.withOpacity(0.8)),
                          ),
                          sizeHorizontal(5),
                          IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, NavigationStrings.commentPage,arguments: AppEntity(uid: _currentUid,postId: widget.post.postId));
                              },
                              icon: const Icon(
                                EvaIcons.messageCircleOutline,
                                size: 25,
                                color: Colors.black87,
                              )),
                          Text(
                            "${widget.post.totalComments} ",
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87.withOpacity(0.8)),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                EvaIcons.shareOutline,
                                size: 25,
                                color: Colors.black87,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                EvaIcons.bookmarkOutline,
                                size: 25,
                                color: Colors.black87,
                              )),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * .02),
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        "All comments",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87.withOpacity(0.8)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text("${widget.post.description}",style: const TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 14,
                        color: Colors.black87,
                      ),),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<MoreItem> buildItem(MoreItem item) => PopupMenuItem(
      value: item,
      child: Row(
        children: [
          Icon(
            item.icon,
            color: item.color,
            size: 20,
          ),
          sizeHorizontal(10),
          Text(
            item.text,
            style: const TextStyle(
                fontFamily: "Roboto",
                fontSize: 16,
                fontWeight: FontWeight.w600),
          )
        ],
      ));
  _deletePost() {
    BlocProvider.of<PostCubit>(context)
        .deletePost(post: PostEntity(postId: widget.post.postId));
  }

  void onSelected(BuildContext context, MoreItem item) {
    switch (item) {
      case SinglePostCardWidget.update:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UpdatePost(
                  post: widget.post,
                )));
        break;
      case SinglePostCardWidget.remove:
        _deletePost();
        break;
    }
  }



  _likePost() {
    BlocProvider.of<PostCubit>(context).likePost(
        post: PostEntity(
          postId: widget.post.postId,
        ));
  }

  commentSection({required UserEntity currentUser}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: FormContainerReply(
        controller: commentController,
        onTap: createComment(currentUser),
        hintText: "Your comment",
      ),
    );
  }

  createComment(UserEntity currentUser){
    BlocProvider.of<CommentCubit>(context).createComment(comment: CommentEntity(
        totalReplays: 0,
        commentId: const Uuid().v1(),
        createdAt: Timestamp.now(),
        likes: [],
        username: currentUser.username,
        userProfileUrl: currentUser.profileUrl,
        description:commentController.text,
        creatorUID: currentUser.uid,
        postId: widget.appEntity.postId
    ));
  }
}
