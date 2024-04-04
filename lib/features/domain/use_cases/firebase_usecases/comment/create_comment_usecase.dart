import 'package:social/features/domain/repositories/firebase_repository.dart';

import '../../../entities/comments/comment_entity.dart';

class CreateCommentUseCase{
  final FirebaseRepository repository;

  CreateCommentUseCase({required this.repository});
  Future<void> callback(CommentEntity comment){
    return repository.createComment(comment);
  }
}