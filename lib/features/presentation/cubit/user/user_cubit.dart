import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social/features/domain/entities/user/user_entity.dart';

import '../../../domain/use_cases/firebase_usecases/user/get_user_usecase.dart';
import '../../../domain/use_cases/firebase_usecases/user/update_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UpdateUserUseCase updateUserUseCase;
  final GetUserUseCase getUserUseCase;

  UserCubit({required this.updateUserUseCase, required this.getUserUseCase}) : super(UserInitial());

  Future<void> getUsers({required UserEntity user}) async{
    emit(UserLoading());
    try{
      final streamResponse =  getUserUseCase.callback(user);
      streamResponse.listen((users) {
        emit(UserLoaded(users: users));
      });

    } on SocketException catch(_){
      emit(UserFailure());
    }catch(_){
      emit(UserFailure());
    }
  }

  Future<void> updateUser({required UserEntity user}) async{
    emit(UserLoading());
    try{
      await updateUserUseCase.callback(user);
    }
    on SocketException catch(_){
      emit(UserFailure());
    }
    catch(_){
      emit(UserFailure());
    }
  }
}
