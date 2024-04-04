import 'dart:io';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/constants.dart';
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:social/features/presentation/pages/main_screen/main_screen.dart';
import 'package:social/features/presentation/pages/profile/widgets/profile_widget.dart';
import 'package:social/features/presentation/widgets/button_container.dart';
import 'package:social/features/presentation/widgets/form_container.dart';
import '../../../../strings.dart';
import '../../cubit/auth/auth_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isSigningUp = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    usernameController.dispose();
    super.dispose();
  }
  File? _image;
  Future selectImage()async{
    try{
      final pickedFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
      setState(() {
        if(pickedFile != null){
          _image = File(pickedFile.path);
        }else{
          print("no image has been selected");
        }
      });
    }catch(e){
      print("some error occured $e");

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<CredentialCubit, CredentialState>(
      listener: (context, credentialState) {
       if(credentialState is CredentialSuccess){
         BlocProvider.of<AuthCubit>(context).loggedIn();
       }
       if(credentialState is CredentialFailure){
         //toast("Invalid email or password",EvaIcons.alertCircleOutline,Colors.red);
         print("Invalid email or password");
       }
      },
      builder: (context, credentialState) {
        if(credentialState is CredentialSuccess){
          return BlocBuilder<AuthCubit,AuthState>(builder: (context,authState){
            if(authState is Authenticated){
              return MainScreen(uid: authState.uid,);
            }else{
             return _bodyWidget();
            }
          });
        }
        return _bodyWidget();
      },
    ));
  }

  _bodyWidget() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .15,
                child: const Center(
                    child: Text(
                  "FindMe.",
                  style: TextStyle(
                      fontFamily: "DancingScript",
                      fontSize: 55,
                      fontWeight: FontWeight.w900,
                      color: primary),
                )),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: profileWidget(image: _image),
                    ),
                  ),

                  Positioned(
                      right: -10,
                      bottom: -15,
                      child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: primary,
                          ))),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 7.5,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      FormContainer(
                        controller: usernameController,
                        hintText: "Username",
                        prefixIcon: Icons.person,
                      ),
                      sizeVertical(10),
                      FormContainer(
                        controller: emailController,
                        hintText: "Email",
                        prefixIcon: Icons.mail,
                      ),
                      sizeVertical(10),
                      FormContainer(
                        controller: passwordController,
                        hintText: "Password",
                        isPasswordField: true,
                        prefixIcon: Icons.lock,
                      ),
                      sizeVertical(10),
                      FormContainer(
                        controller: bioController,
                        hintText: "Biography",
                        prefixIcon: Icons.text_snippet,
                      ),
                      sizeVertical(30),
                      ButtonContainer(
                        text: "SIGN UP",
                        onTapListener: () {
                          //Navigator.pushNamed(context, NavigationStrings.main);
                          _signUpUser();
                        },
                        color: primary.withOpacity(0.8),
                      ),
                      sizeVertical(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.registred_text,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                color: grey400,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          sizeHorizontal(5),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  NavigationStrings.signIn, (route) => false);
                            },
                            child: Text(
                              AppStrings.signin,
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: primary.withOpacity(0.6),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 170),
                        child: Column(
                          children: [
                            Text(
                              "By continuing you agree FindMe Terms of",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w400,
                                  color: grey400,
                                  fontSize: 13),
                            ),
                            Text(
                              "Services & Privacy Policy",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w400,
                                  color: grey400,
                                  fontSize: 13),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signUpUser() {
    setState(() {
      _isSigningUp = true;
    });
    BlocProvider.of<CredentialCubit>(context)
        .signUpUser(
            user: UserEntity(
                email: emailController.text,
                password: passwordController.text,
                username: usernameController.text,
                biography: bioController.text,
                totalPost: 0,
                totalFollowing: 0,
                totalFollowers: 0,
                followers: [],
                following: [],
                profileUrl: '',
                website: '',
                imageFile: _image,
                name: '',
                uid: ''))
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      usernameController.clear();
      emailController.clear();
      passwordController.clear();
      bioController.clear();
      _isSigningUp = false;
    });
  }


}
