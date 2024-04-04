import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/domain/entities/app_entity.dart';
import 'package:social/features/domain/entities/comments/comment_entity.dart';
import 'package:social/features/presentation/pages/post/comments/widgets/comment_main_widget.dart';
import 'package:social/injection_container.dart' as injection;
import '../../../cubit/comment/comment_cubit.dart';
import '../../../cubit/user/get_single_user/get_single_user_cubit.dart';


class CommentScreen extends StatelessWidget {
  const CommentScreen({super.key,required this.appEntity});
  final AppEntity appEntity;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommentCubit>(create: (context) => injection.serviceLocator<CommentCubit>(),),
        BlocProvider<GetSingleUserCubit>(create: (context) => injection.serviceLocator<GetSingleUserCubit>(),
        )
      ],
      child: CommentMainWidget(appEntity: appEntity,),
    );
  }
}
