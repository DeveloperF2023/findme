import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social/constants.dart';


Widget profileWidget({String? imageUrl, File? image}) {
  if (image == null) {
    if (imageUrl == null || imageUrl == "") {
      //Image.asset(
      //         "assets/images/user.jpg",
      //         fit: BoxFit.cover,
      //       );
      return Container(
        color: grey200,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return const CircularProgressIndicator();
        },
        errorWidget: (context, url, error){
          //Image.asset("assets/images/user.jpg",fit: BoxFit.cover,);
         return Container(
           color: grey200,
         );
        },
      );
    }
  }else{
    return Image.file(image,fit: BoxFit.cover);
  }
}
