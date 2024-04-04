import 'dart:io';
import 'package:social/features/domain/use_cases/firebase_usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:social/injection_container.dart' as injection;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/constants.dart';
import 'package:social/features/domain/entities/posts/post_entity.dart';
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/presentation/cubit/post/post_cubit.dart';
import 'package:social/features/presentation/pages/profile/widgets/profile_widget.dart';
import 'package:uuid/uuid.dart';
import '../../../widgets/button_container.dart';
import '../../main_screen/main_screen.dart';

class UploadPostMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  const UploadPostMainWidget({super.key, required this.currentUser});

  @override
  State<UploadPostMainWidget> createState() => _UploadPostMainWidgetState();
}

class _UploadPostMainWidgetState extends State<UploadPostMainWidget> {
  TextEditingController descriptionController = TextEditingController();
  bool _isPosting = false;
  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  File? _image;
  Future selectImage() async {
    try {
      final pickedFile =
          await ImagePicker.platform.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/upload.jpg"))),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * .05,
              left: MediaQuery.of(context).size.width * .04,
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                    color: Colors.white54, shape: BoxShape.circle),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MainScreen(uid: widget.currentUser.uid!)));
                  },
                  child: const Center(
                      child: Icon(
                        EvaIcons.arrowBack,
                        color: black87,
                      )),
                ),
              )),
          Positioned(
            bottom: MediaQuery.of(context).size.height * .2,
            left: MediaQuery.of(context).size.width * .1,
            right: MediaQuery.of(context).size.width * .1,
            child: Container(
              height: MediaQuery.of(context).size.height * .45,
              width: MediaQuery.of(context).size.width * .9,
              decoration: BoxDecoration(
                  color: Colors.white54,
                  border: Border.all(color: Colors.white54, width: 1.5),
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "🚀 Unlock Your Potential ",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.6,
                              color: primary,
                              fontSize: 22),
                        ),

                        ///
                        Text(
                          "with FINDME 👌",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.6,
                              color: primary,
                              fontSize: 22),
                        ),
                      ],
                    ),
                    sizeVertical(20),
                    const Text(
                      "Life is an incredible journey, and it's time to make the most of it. With FindMe, we're here to empower you every step of the way! ✨",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: black87,
                          fontSize: 15),
                    ),
                    sizeVertical(40),
                    ButtonContainer(
                      height: 40,
                      width: 180,
                      color: primary,
                      text: "Create a post",
                      onTapListener: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>CreatePostScreen(currentUser: widget.currentUser)));
                        showBottomCreatePost();
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _savePost({required String image}) {
    BlocProvider.of<PostCubit>(context)
        .createPost(
            post: PostEntity(
                description: descriptionController.text,
                createdAt: Timestamp.now(),
                creatorUID: widget.currentUser.uid,
                likes: [],
                postId: const Uuid().v1(),
                postImageUrl: image,
                totalComments: 0,
                totalLikes: 0,
                username: widget.currentUser.username,
                userProfileUrl: widget.currentUser.profileUrl))
        .then((value) => _clear());
  }

  _submitPost() {
    injection
        .serviceLocator<UploadImageToStorageUseCase>()
        .callback(_image, true, 'posts')
        .then((imageUrl) {
      _savePost(image: imageUrl as String);
    });
  }

  _clear() {
    setState(() {
      descriptionController.clear();
      _image = null;
      Navigator.pop(context);
    });
  }


  showBottomCreatePost() {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           Row(
                             children: [
                               SizedBox(
                                 height: 50,
                                 width: 50,
                                 child: ClipRRect(
                                   borderRadius: BorderRadius.circular(50),
                                   child: profileWidget(
                                       imageUrl:
                                       "${widget.currentUser.profileUrl}"),
                                 ),
                               ),
                               sizeHorizontal(10),
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(
                                     "${widget.currentUser.username}",
                                     style: const TextStyle(
                                         fontFamily: "Roboto",
                                         fontSize: 18,
                                         fontWeight: FontWeight.w600),
                                   ),
                                   Container(
                                     height: 20,
                                     width: 70,
                                     decoration: BoxDecoration(
                                         color: grey200,
                                         borderRadius: BorderRadius.circular(5)),
                                     child: const Padding(
                                       padding:
                                       EdgeInsets.symmetric(horizontal: 2),
                                       child: Row(
                                         mainAxisAlignment:
                                         MainAxisAlignment.spaceBetween,
                                         children: [
                                           Icon(
                                             EvaIcons.globe2Outline,
                                             color: Colors.black54,
                                             size: 16,
                                           ),
                                           Text(
                                             "public",
                                             style: TextStyle(
                                                 fontFamily: "Roboto",
                                                 fontSize: 11,
                                                 fontWeight: FontWeight.w500,
                                                 color: Colors.black54),
                                           ),
                                           Icon(
                                             EvaIcons.arrowDownOutline,
                                             color: Colors.black54,
                                             size: 16,
                                           ),
                                         ],
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                             ],
                           ),
                            GestureDetector(
                              onTap: _submitPost,
                              child: Container(
                                height: MediaQuery.of(context).size.height *.05,
                                width: MediaQuery.of(context).size.width *.25,
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(EvaIcons.checkmarkCircle2,color: Colors.white,size: 23,),
                                    sizeHorizontal(5),
                                    const Text("Save",style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Roboto',
                                      fontSize: 18,
                                      color: Colors.white
                                    ),)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        sizeVertical(20),
                        Stack(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .25,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: profileWidget(image: _image),
                              ),
                            ),
                            Positioned(
                                bottom: 5,
                                right: 5,
                                child: IconButton(
                                    style: IconButton.styleFrom(
                                        backgroundColor:
                                            primary.withOpacity(0.8),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                    onPressed: selectImage,
                                    icon: const Icon(
                                      EvaIcons.editOutline,
                                      color: backgroundColor,
                                      size: 23,
                                    ))),
                          ],
                        ),
                        sizeVertical(20),
                        TextFormField(
                          controller: descriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          cursorColor: primary,
                          decoration: InputDecoration(
                            hintText: "Your Description",
                            hintStyle: TextStyle(
                                fontFamily: "Roboto",
                                color: grey500,
                                fontSize: 16),
                            fillColor: Colors.transparent,
                            filled: false,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            contentPadding:
                                const EdgeInsets.only(top: 20, left: 20),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(width: 1.5, color: grey400!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(width: 1.5, color: grey500!),
                            ),
                          ),
                        ),
                        sizeVertical(20),
                        Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .05,
                              width: MediaQuery.of(context).size.width * .88,
                              child: Row(
                                children: [
                                  const Icon(
                                    EvaIcons.pin,
                                    color: primary,
                                    size: 23,
                                  ),
                                  sizeHorizontal(10),
                                  Text(
                                    "Add Location",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: grey400),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .05,
                              width: MediaQuery.of(context).size.width * .88,
                              child: Row(
                                children: [
                                  const Icon(
                                    EvaIcons.personAdd,
                                    color: primary,
                                    size: 23,
                                  ),
                                  sizeHorizontal(10),
                                  Text(
                                    "@Add Friends",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: grey400),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        _isPosting == true
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            .2),
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width * .8,
                                  decoration: BoxDecoration(
                                      color: grey200,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Please wait ...",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "Roboto",
                                            color: black87,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      sizeHorizontal(10),
                                      const CircularProgressIndicator(
                                        color: primary,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(
                                width: 0,
                                height: 0,
                              )
                      ],
                    ),
                  ),
                ),
              ));
        });
  }
}
