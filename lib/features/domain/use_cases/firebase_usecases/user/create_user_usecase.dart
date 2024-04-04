
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';

class CreateUserUseCase{
  final FirebaseRepository repository;

  CreateUserUseCase({required this.repository});
  Future<void> callback(UserEntity user){
    return repository.createUser(user);
  }
}