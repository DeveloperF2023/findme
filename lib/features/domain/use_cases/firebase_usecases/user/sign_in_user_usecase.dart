
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';

class SignInUserUseCase{
  final FirebaseRepository repository;

  SignInUserUseCase({required this.repository});
  Future<void> callback(UserEntity user){
    return repository.signInUser(user);
  }
}