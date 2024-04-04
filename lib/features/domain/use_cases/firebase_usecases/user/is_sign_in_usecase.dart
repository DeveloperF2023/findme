
import 'package:social/features/domain/entities/user/user_entity.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';

class IsSignInUseCase{
  final FirebaseRepository repository;

  IsSignInUseCase({required this.repository});
  Future<bool> callback(){
    return repository.isSignIn();
  }
}