import 'package:social/features/domain/repositories/firebase_repository.dart';

import '../../../entities/comments/comment_entity.dart';

class LikeCommentUseCase{
  final FirebaseRepository repository;

  LikeCommentUseCase({required this.repository});
  Future<void> callback(CommentEntity comment){
    return repository.likeComment(comment);
  }
}