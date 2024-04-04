import 'dart:io';
import 'package:social/features/domain/use_cases/firebase_usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:social/injection_container.dart'as injection;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/features/domain/entities/posts/post_entity.dart';
import 'package:social/features/presentation/cubit/post/post_cubit.dart';
import 'package:social/features/presentation/pages/profile/widgets/app_bar_edit.dart';
import '../../../../../constants.dart';
import '../../profile/widgets/profile_widget.dart';

class UpdatePostMainWidget extends StatefulWidget {
  const UpdatePostMainWidget({super.key, required this.post});
  final PostEntity post;
  @override
  State<UpdatePostMainWidget> createState() => _UpdatePostMainWidgetState();
}

class _UpdatePostMainWidgetState extends State<UpdatePostMainWidget> {
  TextEditingController? descriptionController;
  @override
  void initState() {
    descriptionController = TextEditingController(text: widget.post.description);
    super.initState();
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
      print("some error occurred $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:  AppBarEditProfileWidget(
        onPressed: _updatePost,
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Padding(
                padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height *.1),
                child: Column(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: profileWidget(imageUrl: "${widget.post.userProfileUrl}"),
                      ),
                    ),
                    sizeVertical(15),
                    Text("${widget.post.username}",style: const TextStyle(
                        color: Colors.black87,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w600,
                        fontSize: 17
                    ),)
                  ],
                ),
              ),
              sizeVertical(20),
              Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height *.3,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: profileWidget(imageUrl: "${widget.post.postImageUrl}",image: _image),
                    ),
                  ),
                  Positioned(
                      bottom: 5,
                      right: 5,
                      child: IconButton(
                          style: IconButton.styleFrom(
                              backgroundColor: primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)
                              )
                          ),
                          onPressed: selectImage, icon: const Icon(EvaIcons.editOutline,color: backgroundColor,size: 23,))),
                ],
              ),
              sizeVertical(20),
              Column(
                children: [
                  TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: "${widget.post.description}"
                    ),
                  )
                ],
              )

            ],
          ),
        )),
      ),
    );
  }

  _updatePost(){
    if(_image == null){
      _submitUpdatePost(image: widget.post.postImageUrl!);
    }
    else{
      injection.serviceLocator<UploadImageToStorageUseCase>().callback(_image, true, "posts").then((imageUrl){
        _submitUpdatePost(image: imageUrl as String);
      });
    }
  }
  _submitUpdatePost({ required String image }){
    BlocProvider.of<PostCubit>(context).updatePost(post: PostEntity(
      creatorUID: widget.post.creatorUID,
      postId: widget.post.postId,
      postImageUrl: image,
      description: descriptionController!.text,
    )).then((value){
      clear();
    });
  }

  void clear() {
    setState(() {
      _image = null;
      descriptionController!.clear();
      Navigator.pop(context);
    });
  }
}
