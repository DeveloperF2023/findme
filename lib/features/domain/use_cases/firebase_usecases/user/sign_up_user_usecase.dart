
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';

class SignUpUserUseCase{
  final FirebaseRepository repository;

  SignUpUserUseCase({required this.repository});
  Future<void> callback(UserEntity user){
    return repository.signUpUser(user);
  }
}