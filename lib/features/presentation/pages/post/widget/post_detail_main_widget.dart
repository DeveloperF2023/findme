import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/constants.dart';
import 'package:social/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:social/features/presentation/cubit/post/post_cubit.dart';
import 'package:social/injection_container.dart' as injection;
import '../../../../domain/entities/app_entity.dart';
import '../../../../domain/entities/posts/post_entity.dart';
import '../../../../domain/use_cases/firebase_usecases/user/get_current_uid_usecase.dart';
import '../../../cubit/get_single_post/get_single_post_cubit.dart';
import '../../../cubit/reply/replay_cubit.dart';
import '../../profile/widgets/profile_widget.dart';
import '../comments/widgets/single_replay_widget.dart';
import '../comments/widgets/text_field_reply.dart';


class PostDetailMainWidget extends StatefulWidget {
  const PostDetailMainWidget({super.key, required this.postId});
  final String postId;
  @override
  State<PostDetailMainWidget> createState() => _PostDetailMainWidgetState();
}

class _PostDetailMainWidgetState extends State<PostDetailMainWidget> {
  bool isUserReplying = false;
  TextEditingController replyController = TextEditingController();
  String _currentUid = "";
  @override
  void initState() {

    BlocProvider.of<GetSinglePostCubit>(context).getSinglePost(postId: widget.postId);

    injection.serviceLocator<GetCurrentUIDUseCase>().callback().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  bool _isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
  builder: (context, getSinglePostState) {
      if (getSinglePostState is GetSinglePostLoaded) {
        final singlePost = getSinglePostState.post;
        return Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height *.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: profileWidget(imageUrl: "${singlePost.postImageUrl}")),
            ),
          ),
          Positioned(
            top: 25,
            left: 10,
            child: Container(
              height: MediaQuery.of(context).size.height *.05,
              width: MediaQuery.of(context).size.width*.1,
              decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle
              ),
              child: IconButton(onPressed: (){
                Navigator.pushNamed(context, NavigationStrings.main);
              }, icon: const Icon(EvaIcons.arrowBackOutline,color: Colors.white,size: 20,)),
            ),
          ),
          Positioned(
            top: 25,
            right: 10,
            child: Container(
              height: MediaQuery.of(context).size.height *.05,
              width: MediaQuery.of(context).size.width*.1,
              decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle
              ),
              child: IconButton(onPressed: (){}, icon: const Icon(EvaIcons.moreHorizontal,color: Colors.white,size: 20,)),
            ),
          ),
          Positioned(
            bottom: 340,
            right: 0,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height *.06,
              width: MediaQuery.of(context).size.width*.12,
              decoration: const BoxDecoration(
                color: backgroundColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [

                      IconButton(
                          onPressed: _likePost,
                          icon: Icon(
                            singlePost.likes!.contains(_currentUid)
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: singlePost.likes!.contains(_currentUid)
                                ? Colors.red
                                : primary,
                          )),
                      //${widget.post.totalLikes}
                      Text(
                        "${singlePost.totalLikes} likes",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87.withOpacity(0.8)),
                      ),
                      sizeHorizontal(10),
                      IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, NavigationStrings.commentPage,arguments: AppEntity(uid: _currentUid,postId: singlePost.postId));
                          },
                          icon: const Icon(
                            EvaIcons.messageCircleOutline,
                            size: 25,
                            color: Colors.black87,
                          )),
                      //"${widget.post.totalComments} "
                      Text(
                        "${singlePost.totalComments} comments",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87.withOpacity(0.8)),
                      ),
                      sizeHorizontal(10),
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
            ),
          ),


        ],
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );

    })
    );
  }
  _likePost() {
    BlocProvider.of<PostCubit>(context).likePost(post: PostEntity(
        postId: widget.postId
    ));
  }
}
