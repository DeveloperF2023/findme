import 'package:social/features/domain/entities/posts/post_entity.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';

class ReadPostUseCase{
  final FirebaseRepository repository;

  ReadPostUseCase({required this.repository});
  Stream<List<PostEntity>> callback(PostEntity post){
    return repository.readPosts(post);
  }
}