import 'package:social/features/domain/entities/posts/post_entity.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';

class UpdatePostUseCase{
  final FirebaseRepository repository;

  UpdatePostUseCase({required this.repository});
  Future<void> callback(PostEntity post){
    return repository.updatePost(post);
  }
}