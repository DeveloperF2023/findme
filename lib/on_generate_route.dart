
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social/constants.dart';
import 'package:social/features/domain/entities/app_entity.dart';
import 'package:social/features/domain/entities/comments/comment_entity.dart';
import 'package:social/features/domain/entities/posts/post_entity.dart';
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/presentation/pages/Authentication/sign_in_screen.dart';
import 'package:social/features/presentation/pages/Authentication/sign_up_screen.dart';
import 'package:social/features/presentation/pages/home/home_screen.dart';
import 'package:social/features/presentation/pages/home/widget/single_post_widget.dart';
import 'package:social/features/presentation/pages/main_screen/main_screen.dart';
import 'package:social/features/presentation/pages/post/comments/comment_screen.dart';
import 'package:social/features/presentation/pages/post/create_post.dart';
import 'package:social/features/presentation/pages/post/post_detail_page.dart';
import 'package:social/features/presentation/pages/post/update_post.dart';
import 'package:social/features/presentation/pages/profile/edit_profile_screen.dart';

import 'features/presentation/pages/post/widget/upload _post_main.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings){
    final args = settings.arguments;
    final String? uid = const UserEntity().uid;
    switch(settings.name){

      case NavigationStrings.editProfile:{
        if(args is UserEntity){
          return routeBuilder(EditProfileScreen(currentUser: args,));
        }
        else{
          print("error");
        }
      }
      case NavigationStrings.editPost:{
        if(args is PostEntity){
          return routeBuilder(UpdatePost(post: args,));
        }
      }
      case NavigationStrings.signIn:{
        return routeBuilder(const SignInScreen());
      }
      case NavigationStrings.signUp:{
        return routeBuilder(const SignUpScreen());
      }
      case NavigationStrings.uploadPost:{
        if(args is UserEntity){
          return routeBuilder(CreatePostScreen(currentUser: args,));
        }
      }
      case NavigationStrings.commentPage:{
        if(args is AppEntity ){
          return routeBuilder( CommentScreen(appEntity: args));
        }
      }
      case NavigationStrings.postDetail:{
        if(args is String)
        return routeBuilder( PostDetailPage(postId: args,));
      }

    }

  }

}
dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(builder: (context)=>child);
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page not found"),
      ),
      body: Center(child: Text("Page not found"),),
    );
  }
}