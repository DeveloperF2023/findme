import 'package:social/features/domain/entities/replay/replay_entity.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';


class UpdateReplayUseCase{
  final FirebaseRepository repository;
  UpdateReplayUseCase({required this.repository});
  Future<void> callback(ReplayEntity replay){
    return repository.updateReplay(replay);
  }
}