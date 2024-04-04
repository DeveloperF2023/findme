import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/constants.dart';
import 'package:social/features/domain/entities/app_entity.dart';
import 'package:social/features/domain/entities/posts/post_entity.dart';
import 'package:social/features/presentation/cubit/post/post_cubit.dart';
import 'package:social/features/presentation/pages/home/widget/single_post_widget.dart';
import 'package:social/injection_container.dart' as injection;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "FindMe.",
            style: TextStyle(
                fontFamily: "DancingScript",
                fontSize: 35,
                fontWeight: FontWeight.w900,
                color: primary),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  EvaIcons.messageSquare,
                  color: primary,
                ))
          ],
        ),
        body: BlocProvider<PostCubit>(
          create: (context) => injection.serviceLocator<PostCubit>()
            ..readPosts(post: const PostEntity()),
          child:
              BlocBuilder<PostCubit, PostState>(builder: (context, postState) {
            //if (postState is PostLoading) {
                //               return const Center(
                //                 child: CircularProgressIndicator(),
                //               );
                //             }
            if (postState is PostFailure) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("some errors occurred "),
              ));
            }
            if (postState is PostLoaded) {
              return postState.posts.isEmpty
                  ? _noPostYetWidget()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: postState.posts.length,
                      itemBuilder: (context, index) {
                        final post = postState.posts[index];
                        return BlocProvider(
                          create: (context) =>
                              injection.serviceLocator<PostCubit>(),
                          child: SinglePostCardWidget(post: post,appEntity: AppEntity(uid: post.creatorUID!),),
                        );
                      });
            }
            return const Center(
                child: CircularProgressIndicator(),
            );
          }),
        ));
  }

  _noPostYetWidget() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(image: AssetImage("assets/images/error.png")),
          sizeVertical(20),
          const Text(
            " No Post Yet",
            style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 15,
                color: black87,
                fontWeight: FontWeight.w400),
          ),
          sizeVertical(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "Oops! It looks like there are no posts to display right now. Stay tuned for exciting updates and engaging content coming your way soon. In the meantime, feel free to explore other features of our app, connect with friends, or share your own amazing moments. Your social media journey is just a click away!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 12,
                  color: grey400,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
