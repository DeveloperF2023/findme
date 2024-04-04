
import 'dart:io';
import 'package:social/features/domain/repositories/firebase_repository.dart';

class UploadImageToStorageUseCase{
  final FirebaseRepository repository;

  UploadImageToStorageUseCase({required this.repository});
  Future<void> callback(File? file,bool isPost,String childName){
    return repository.uploadImageToStorage(file, isPost, childName);
  }
}