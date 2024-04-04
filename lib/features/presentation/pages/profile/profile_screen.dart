import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/presentation/cubit/post/post_cubit.dart';
import 'package:social/features/presentation/pages/profile/widgets/profile_main_widget.dart';
import 'package:social/injection_container.dart' as injection;
class ProfilePage extends StatelessWidget {
  final UserEntity currentUser;
  const ProfilePage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>injection.serviceLocator<PostCubit>(),
      child: ProfileMainWidget(currentUser: currentUser,),);
  }
}
