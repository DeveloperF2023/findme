import 'package:social/features/domain/repositories/firebase_repository.dart';

import '../../../entities/comments/comment_entity.dart';

class ReadCommentUseCase{
  final FirebaseRepository repository;

  ReadCommentUseCase({required this.repository});
  Stream<List<CommentEntity>> callback(String postId){
    return repository.readComments(postId);
  }
}