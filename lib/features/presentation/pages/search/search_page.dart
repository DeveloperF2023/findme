import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/presentation/cubit/post/post_cubit.dart';
import 'package:social/features/presentation/pages/search/widgets/search_main_widget.dart';
import 'package:social/injection_container.dart' as injection;

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => injection.serviceLocator<PostCubit>(),
      child: const SearchMainWidget(),
    );
  }
}
