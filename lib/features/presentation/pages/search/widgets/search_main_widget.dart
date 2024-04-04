import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/domain/entities/posts/post_entity.dart';
import 'package:social/features/presentation/cubit/post/post_cubit.dart';
import 'package:social/features/presentation/pages/profile/widgets/profile_widget.dart';
import 'package:social/features/presentation/widgets/app_bar.dart';
import 'package:social/features/presentation/pages/search/widgets/text_field_search.dart';
import '../../../../../constants.dart';

class SearchMainWidget extends StatefulWidget {
  const SearchMainWidget({super.key});

  @override
  State<SearchMainWidget> createState() => _SearchMainWidgetState();
}

class _SearchMainWidgetState extends State<SearchMainWidget> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<PostCubit>(context).readPosts(post: PostEntity());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchWidget(
                    controller: searchController,
                  ),
                  sizeVertical(10),
                  BlocBuilder<PostCubit, PostState>(
                    builder: (_, postState) {
                      if(postState is PostLoaded){
                        final posts = postState.posts;
                        return GridView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: posts.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 150,
                                crossAxisCount: 3,
                                crossAxisSpacing: 3,
                                mainAxisSpacing: 5),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, NavigationStrings.postDetail,arguments: posts[index].postId);
                                },
                                child: Container(
                                  child: profileWidget(
                                      imageUrl: posts[index].postImageUrl
                                  ),
                                ),
                              );
                            });
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
