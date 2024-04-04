
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';

class UpdateUserUseCase{
  final FirebaseRepository repository;

  UpdateUserUseCase({required this.repository});
  Future<void> callback(UserEntity user){
    return repository.updateUser(user);
  }
}