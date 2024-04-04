import 'package:social/features/domain/entities/posts/post_entity.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';

class DeletePostUseCase{
  final FirebaseRepository repository;

  DeletePostUseCase({required this.repository});
  Future<void> callback(PostEntity post){
    return repository.deletePost(post);
  }
}