import 'package:social/features/domain/entities/replay/replay_entity.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';

import '../../../entities/comments/comment_entity.dart';

class ReadReplaysUseCase{
  final FirebaseRepository repository;

  ReadReplaysUseCase({required this.repository});
  Stream<List<ReplayEntity>> callback(ReplayEntity replay){
    return repository.readReplays(replay);
  }
}