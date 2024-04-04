import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/constants.dart';
import 'package:social/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:social/features/presentation/pages/profile/edit_profile_screen.dart';

import '../../../../domain/entities/user/user_entity.dart';

class ButtonContainer extends StatefulWidget {
  const ButtonContainer({super.key,required this.currentUser});
  final UserEntity currentUser;

  @override
  State<ButtonContainer> createState() => _ButtonContainerState();
}

class _ButtonContainerState extends State<ButtonContainer> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
