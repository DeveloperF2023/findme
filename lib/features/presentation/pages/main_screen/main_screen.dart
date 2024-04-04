import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:social/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:social/features/presentation/pages/activity/activity_screen.dart';
import 'package:social/features/presentation/pages/home/home_screen.dart';
import 'package:social/features/presentation/pages/post/create_post.dart';
import 'package:social/features/presentation/pages/profile/profile_screen.dart';
import 'package:social/features/presentation/pages/search/search_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.uid});

  final String uid;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPage = 0;
  final PageController pageController = PageController();
  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    super.initState();
  }
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, getSingleUserState) {
        if(getSingleUserState is GetSingleUserLoaded){
          final currentUser = getSingleUserState.user;
          return Scaffold(
            body: PageView(
              controller: pageController,
              onPageChanged: ((value) {
                setState(() {
                  ///update page index
                  currentPage = value;
                });
              }),
              children: [
                const HomeScreen(),
                const SearchPage(),
                CreatePostScreen(currentUser: currentUser,),
                const ActivityScreen(),
                ProfilePage(currentUser:currentUser,)
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: currentPage,
                backgroundColor: Colors.white,
                selectedItemColor: primary,
                unselectedItemColor: grey400,
                elevation: 10,
                onTap: (page) {
                  setState(() {
                    currentPage = page;
                    pageController.animateToPage(page,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                      activeIcon: Icon(EvaIcons.home),
                      icon: Icon(EvaIcons.homeOutline),
                      label: "Home"
                  ),
                  BottomNavigationBarItem(
                      activeIcon: Icon(EvaIcons.search),
                      icon: Icon(EvaIcons.searchOutline),
                      label: "Search"
                  ),
                  BottomNavigationBarItem(
                      activeIcon: Icon(EvaIcons.plusCircle),
                      icon: Icon(EvaIcons.plusCircleOutline),
                      label: "Post"
                  ),
                  BottomNavigationBarItem(
                      activeIcon: Icon(EvaIcons.heart),
                      icon: Icon(EvaIcons.heartOutline),
                      label: "Favorite"
                  ),
                  BottomNavigationBarItem(
                      activeIcon: Icon(EvaIcons.person),
                      icon: Icon(EvaIcons.personOutline),
                      label: "Profile"
                  ),
                ]),
          );
        }
       return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
