import 'package:social/features/domain/entities/posts/post_entity.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';

class ReadSinglePostUseCase{
  final FirebaseRepository repository;

  ReadSinglePostUseCase({required this.repository});
  Stream<List<PostEntity>> callback(String postId){
    return repository.readSinglePost(postId);
  }
}