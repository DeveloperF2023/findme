
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';

class SignOutUseCase{
  final FirebaseRepository repository;

  SignOutUseCase({required this.repository});
  Future<void> callback(){
    return repository.signOut();
  }
}