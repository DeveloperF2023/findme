import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social/features/domain/entities/user/user_entity.dart';
import '../../../../domain/use_cases/firebase_usecases/user/get_single_user_usecase.dart';

part 'get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final GetSingleUserUseCase getSingleUserUseCase;
  GetSingleUserCubit({required this.getSingleUserUseCase}) : super(GetSingleUserInitial());

  Future<void> getSingleUser({required String uid}) async{
    emit(GetSingleUserLoading());
    try{
      final streamResponse =  getSingleUserUseCase.callback(uid);
      streamResponse.listen((users) {
        emit(GetSingleUserLoaded(user: users.first));
      });

    } on SocketException catch(_){
      emit(GetSingleUserFailure());
    }catch(_){
      emit(GetSingleUserFailure());
    }
  }


}
