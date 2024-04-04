import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social/features/domain/entities/user/user_entity.dart';
import '../../../domain/use_cases/firebase_usecases/user/sign_in_user_usecase.dart';
import '../../../domain/use_cases/firebase_usecases/user/sign_up_user_usecase.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignInUserUseCase signInUserUseCase;
  final SignUpUserUseCase signUpUserUseCase;
  CredentialCubit({required this.signInUserUseCase, required this.signUpUserUseCase}) :
        super(CredentialInitial());

  Future<void> signInUser({required String email, required String password}) async{
    emit(CredentialLoading());
    try{
      await signInUserUseCase.callback(UserEntity(email: email,password: password));
      emit(CredentialSuccess());
    }
   on SocketException catch(_){
      emit(CredentialFailure());
    }
    catch(_){
      emit(CredentialFailure());
    }
  }

  Future<void> signUpUser({required UserEntity user}) async{
    emit(CredentialLoading());
    try{
      await signUpUserUseCase.callback(user);
      emit(CredentialSuccess());
    }
    on SocketException catch(_){
      emit(CredentialFailure());
    }
    catch(_){
      emit(CredentialFailure());
    }
  }
}
