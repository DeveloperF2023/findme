import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/presentation/cubit/get_single_post/get_single_post_cubit.dart';
import 'package:social/features/presentation/pages/post/widget/post_detail_main_widget.dart';
import 'package:social/injection_container.dart' as injection;

import '../../cubit/post/post_cubit.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key, required this.postId});

  final String postId;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetSinglePostCubit>(
          create: (context) => injection.serviceLocator<GetSinglePostCubit>(),
        ),
        BlocProvider<PostCubit>(
          create: (context) => injection.serviceLocator<PostCubit>(),
        ),
      ],
      child: PostDetailMainWidget(postId: widget.postId,),
    );
  }
}
