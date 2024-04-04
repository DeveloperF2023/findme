import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/user/sign_out_usecase.dart';
import '../../../domain/use_cases/firebase_usecases/user/get_current_uid_usecase.dart';
import '../../../domain/use_cases/firebase_usecases/user/is_sign_in_usecase.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignOutUseCase signOutUseCase;
  final IsSignInUseCase isSignInUseCase;
  final GetCurrentUIDUseCase getCurrentUIDUseCase;
  AuthCubit(
      {required this.signOutUseCase,
      required this.isSignInUseCase,
      required this.getCurrentUIDUseCase})
      : super(AuthInitial());
  Future<void> appStarted(BuildContext context) async{
    try{
      bool isSignIn= await isSignInUseCase.callback();
      if(isSignIn == true){
        final uid = await getCurrentUIDUseCase.callback();
        emit(Authenticated(uid: uid));
      }else {
        emit(UnAuthenticated());
      }
    }catch(_){
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedIn() async{
    try{
      final uid= await getCurrentUIDUseCase.callback();
      emit(Authenticated(uid: uid));
    }
    catch(_){
      emit(UnAuthenticated());
    }
  }
  Future<void> loggedOut() async{
    try{
      await signOutUseCase.callback();
      emit(UnAuthenticated());
    }catch(_){
      emit(UnAuthenticated());
    }
  }
}
