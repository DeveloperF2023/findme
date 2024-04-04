import 'dart:async';
import 'dart:io';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/constants.dart';
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:social/features/presentation/cubit/user/user_cubit.dart';
import 'package:social/features/presentation/pages/profile/widgets/app_bar_edit.dart';
import 'package:social/features/presentation/pages/profile/widgets/profile_widget.dart';

import 'package:social/features/presentation/widgets/form_container.dart';
import 'package:social/injection_container.dart' as injection;

class EditProfileScreen extends StatefulWidget {
  final UserEntity currentUser;
  const EditProfileScreen({super.key, required this.currentUser});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  @override
  void initState() {
    nameController = TextEditingController(text: widget.currentUser.name);
    usernameController = TextEditingController(text: widget.currentUser.username);
    websiteController = TextEditingController(text: widget.currentUser.website);
    bioController = TextEditingController(text: widget.currentUser.biography);
    super.initState();
  }
  bool _isUpdating = false;
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
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar:  AppBarEditProfileWidget(
        onPressed: _updateUserProfileData,
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 100),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: profileWidget(imageUrl: "${widget.currentUser.profileUrl}",image: _image),
                      ),
                    ),
                    Positioned(
                        bottom: -10,
                        right: -10,
                        child: IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: primary
                            ),
                            onPressed: selectImage, icon: const Icon(EvaIcons.editOutline,color: backgroundColor,size: 23,)))
                  ],
                )
              ),
              sizeVertical(30),
              FormContainer(
                controller: nameController,
                hintText: "Name",
                prefixIcon: EvaIcons.person,
                isFilled: false,
              ),
              sizeVertical(10),
              FormContainer(
                controller: usernameController,
                hintText: "Username",
                prefixIcon: EvaIcons.personOutline,
                isFilled: false,
              ),
              sizeVertical(10),
              FormContainer(
                controller: websiteController,
                hintText: "Website",
                prefixIcon: EvaIcons.link,
                isFilled: false,
              ),
              sizeVertical(10),
              FormContainer(
                controller: bioController,
                hintText: "Biography",
                prefixIcon: EvaIcons.textOutline,
                isFilled: false,
              ),


            ],
          ),
        ),
      )),

    );
  }
  _updateUserProfileData(){
   if(_image == null){
     _updateUserProfile("");
   }
   else{
     injection.serviceLocator<UploadImageToStorageUseCase>().callback(_image!, false, "profileImages").then((profileUrl) {
       _updateUserProfile(profileUrl as String);
     });
   }
  }

  _updateUserProfile(String profileUrl){
    setState(() {
      _isUpdating = true;
    });
    BlocProvider.of<UserCubit>(context).updateUser(user: UserEntity(
      uid: widget.currentUser.uid,
      username: usernameController.text,
      biography: bioController.text,
      website: websiteController.text,
      name: nameController.text,
      profileUrl: profileUrl
    )).then((value) => clear());
  }

  clear() {
    setState(() {
      _isUpdating = false;
      usernameController.clear();
      bioController.clear();
      websiteController.clear();
      nameController.clear();
    });
    Navigator.pop(context);
  }
}
