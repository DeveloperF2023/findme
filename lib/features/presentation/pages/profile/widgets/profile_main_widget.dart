import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/constants.dart';
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/presentation/pages/profile/widgets/button_container.dart';
import 'package:social/features/presentation/pages/profile/widgets/profile_widget.dart';
import 'package:social/features/presentation/widgets/app_bar.dart';
import '../../../../domain/entities/posts/post_entity.dart';
import '../../../cubit/auth/auth_cubit.dart';
import '../../../cubit/post/post_cubit.dart';
class ProfileMainWidget extends StatefulWidget {
  const ProfileMainWidget({super.key, required this.currentUser});
  final UserEntity currentUser;
  @override
  State<ProfileMainWidget> createState() => _ProfileMainWidgetState();
}

class _ProfileMainWidgetState extends State<ProfileMainWidget> {
  @override
  void initState() {
    BlocProvider.of<PostCubit>(context).readPosts(post: const PostEntity());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: backgroundColor,
        appBar: const AppBarWidget(),
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ///header(profile image + username+biography
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: profileWidget(imageUrl: "${widget.currentUser.profileUrl}"),
                          ),
                        ),
                        sizeHorizontal(15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("${widget.currentUser.username}",style: const TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 27,
                                fontWeight: FontWeight.w500,
                                color: black87
                            ),),
                            Container(
                              width: MediaQuery.of(context).size.width*.6,
                              child: Text("${widget.currentUser.biography}",
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: grey400
                                ),),
                            ),
                            sizeVertical(10),
                Row(
                  children: [
                    Container(
                      height: 32,
                      width: 130,
                      decoration: BoxDecoration(
                          color: const Color(0xffD6EAF8),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, NavigationStrings.editProfile,arguments: widget.currentUser);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  const Icon(EvaIcons.edit,color: primary,size: 20,),
                                  sizeHorizontal(5),
                                  const Text("Edit Profile",style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),)
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    sizeHorizontal(10),
                    GestureDetector(
                      onTap: (){
                        BlocProvider.of<AuthCubit>(context).loggedOut();
                        Navigator.pushNamedAndRemoveUntil(context, NavigationStrings.signIn, (route) => false);
                      },
                      child: Container(
                          height: 32,
                          width: 40,
                          decoration: BoxDecoration(
                              color: const Color(0xffE8F6F3),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: const Center(
                            child: Icon(EvaIcons.logOut,color: Color(0xff16A085),size: 20,),
                          )
                      ),
                    )
                  ],
                ),
                          ],
                        )
                      ],
                    ),
                    sizeVertical(20),
                    ///number of followers,following, posts
                    Container(
                      height: MediaQuery.of(context).size.height *.1,
                      width: MediaQuery.of(context).size.width*.9,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${widget.currentUser.totalFollowers}",style: const TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: black87
                              ),),
                              Text("Followers",style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: grey400
                              ),),
                            ],
                          ),
                          Container(
                            height: 25,
                            child: VerticalDivider(
                              width: 1,
                              thickness: 2,
                              color: grey200,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${widget.currentUser.totalFollowing}",style: const TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: black87
                              ),),
                              Text("Following",style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: grey400
                              ),),
                            ],
                          ),
                          Container(
                            height: 25,
                            child: VerticalDivider(
                              width: 1,
                              thickness: 2,
                              color: grey200,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${widget.currentUser.totalPost}",style: const TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: black87
                              ),),
                              Text("Posts",style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: grey400
                              ),),

                            ],
                          ),
                        ],
                      ),
                    ),
                    sizeVertical(20),
                    GridView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: 3,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 5,mainAxisSpacing: 5),
                        itemBuilder:(context,index){
                          return Container(
                            height: 100,
                            width: 100,
                            color: grey500,
                          );
                        })
                  ],
                ),
              ),
            )));
  }
}
