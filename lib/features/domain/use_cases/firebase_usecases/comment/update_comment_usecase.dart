import 'package:social/features/domain/repositories/firebase_repository.dart';

import '../../../entities/comments/comment_entity.dart';

class UpdateCommentUseCase{
  final FirebaseRepository repository;

  UpdateCommentUseCase({required this.repository});
  Future<void> callback(CommentEntity comment){
    return repository.updateComment(comment);
  }
}