import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';

class GetCurrentUIDUseCase{
  final FirebaseRepository repository;

  GetCurrentUIDUseCase({required this.repository});
  Future<String> callback(){
    return repository.getCurrentUID();
  }
}