import 'package:social/features/presentation/pages/post/widget/update_post_main_widget.dart';
import 'package:social/injection_container.dart'as injection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/domain/entities/posts/post_entity.dart';
import 'package:social/features/presentation/cubit/post/post_cubit.dart';


class UpdatePost extends StatelessWidget {
  const UpdatePost({super.key, required this.post});
  final PostEntity post;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
        create: (context)=>injection.serviceLocator<PostCubit>(),
       child: UpdatePostMainWidget(post: post));
  }
}