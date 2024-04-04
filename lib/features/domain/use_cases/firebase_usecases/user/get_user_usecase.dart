
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';

class GetUserUseCase{
  final FirebaseRepository repository;

  GetUserUseCase({required this.repository});

  Stream<List<UserEntity>> callback(UserEntity user){
    return repository.getUsers(user);
  }
}