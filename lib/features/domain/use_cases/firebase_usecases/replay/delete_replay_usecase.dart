import 'package:social/features/domain/entities/replay/replay_entity.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';

import '../../../entities/comments/comment_entity.dart';

class DeleteReplayUseCase{
  final FirebaseRepository repository;

  DeleteReplayUseCase({required this.repository});
  Future<void> callback(ReplayEntity replay){
    return repository.deleteReplay(replay);
  }
}