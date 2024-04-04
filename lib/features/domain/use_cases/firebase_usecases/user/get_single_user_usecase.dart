
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';

class GetSingleUserUseCase{
  final FirebaseRepository repository;

  GetSingleUserUseCase({required this.repository});
  Stream<List<UserEntity>> callback(String uid){
    return repository.getSingleUser(uid);
  }
}