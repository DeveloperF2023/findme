import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/presentation/cubit/post/post_cubit.dart';
import 'package:social/features/presentation/pages/post/widget/upload%20_post_main.dart';
import 'package:social/injection_container.dart' as injection;

class CreatePostScreen extends StatelessWidget {
  final UserEntity currentUser;

  const CreatePostScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => injection.serviceLocator<PostCubit>(),
      child: UploadPostMainWidget(currentUser: currentUser),
    );
  }
}
