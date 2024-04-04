import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:social/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:social/features/data/data_sources/remote_data_source/remote_data_source_impl.dart';
import 'package:social/features/data/repositories/firebase_repository_implementation.dart';
import 'package:social/features/domain/repositories/firebase_repository.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/post/create_post_usecase.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/post/delete_post_usecase.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/post/like_post_usecase.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/post/read_posts_usecase.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/post/read_single_post_usecase.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/post/update_post_usecase.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/replay/create_replay_usecase.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/user/create_user_usecase.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/user/get_user_usecase.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/user/is_sign_in_usecase.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/user/sign_in_user_usecase.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/user/sign_out_usecase.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/user/sign_up_user_usecase.dart';
import 'package:social/features/domain/use_cases/firebase_usecases/user/update_user_usecase.dart';
import 'package:social/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:social/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:social/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:social/features/presentation/cubit/get_single_post/get_single_post_cubit.dart';
import 'package:social/features/presentation/cubit/post/post_cubit.dart';
import 'package:social/features/presentation/cubit/reply/replay_cubit.dart';
import 'package:social/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:social/features/presentation/cubit/user/user_cubit.dart';

import 'features/domain/use_cases/firebase_usecases/comment/create_comment_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/comment/delete_comment_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/comment/like_comment_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/comment/read_comment_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/comment/update_comment_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/replay/delete_replay_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/replay/like_replay_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/replay/read_replays_usecase.dart';
import 'features/domain/use_cases/firebase_usecases/replay/update_replay_usecase.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  ///Cubits
  serviceLocator.registerFactory(
    () => AuthCubit(
      signOutUseCase: serviceLocator.call(),
      isSignInUseCase: serviceLocator.call(),
      getCurrentUIDUseCase: serviceLocator.call(),
    ),
  );
  serviceLocator.registerFactory(
    () => CredentialCubit(
      signInUserUseCase: serviceLocator.call(),
      signUpUserUseCase: serviceLocator.call(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserCubit(
      updateUserUseCase: serviceLocator.call(),
      getUserUseCase: serviceLocator.call(),
    ),
  );
  serviceLocator.registerFactory(
    () => GetSingleUserCubit(
      getSingleUserUseCase: serviceLocator.call(),
    ),
  );
  serviceLocator.registerFactory(
        () => PostCubit(
      createPostUseCase: serviceLocator.call(),
      updatePostUseCase: serviceLocator.call(),
      deletePostUseCase: serviceLocator.call(),
      readPostUseCase: serviceLocator.call(),
      likePostUseCase: serviceLocator.call(),
    ),
  );
  serviceLocator.registerFactory(
        () => CommentCubit(
      createCommentUseCase: serviceLocator.call(),
      updateCommentUseCase: serviceLocator.call(),
      deleteCommentUseCase: serviceLocator.call(),
      readCommentUseCase: serviceLocator.call(),
      likeCommentUseCase: serviceLocator.call(),
    ),
  );

  serviceLocator.registerFactory(
        () => GetSinglePostCubit(readSinglePostUseCase:  serviceLocator.call(),
    ),
  );
  serviceLocator.registerFactory(
        () => ReplayCubit(
          createReplayUseCase:  serviceLocator.call(),
          readReplayUseCase: serviceLocator.call(),
          deleteReplayUseCase: serviceLocator.call(),
          likeReplayUseCase: serviceLocator.call(),
          updateReplayUseCase: serviceLocator.call()
    ),
  );

  ///Use Cases
  serviceLocator.registerLazySingleton(
      () => SignOutUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
      () => CreateUserUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
      () => GetCurrentUIDUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
      () => GetSingleUserUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
      () => GetUserUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
      () => IsSignInUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
      () => SignInUserUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
      () => SignUpUserUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
      () => UpdateUserUseCase(repository: serviceLocator.call()));

  ///Cloud storage
  serviceLocator.registerLazySingleton(
      () => UploadImageToStorageUseCase(repository: serviceLocator.call()));

  ///Repository
  serviceLocator.registerLazySingleton<FirebaseRepository>(() =>
      FirebaseRepositoryImplementation(
          remoteDataSource: serviceLocator.call()));

  ///Remote Data Source
  serviceLocator.registerLazySingleton<FirebaseRemoteDataSource>(
      () => FirebaseRemoteDataSourceImpl(
            firebaseFirestore: serviceLocator.call(),
            firebaseAuth: serviceLocator.call(),
            firebaseStorage: serviceLocator.call(),
          ));
  ///Post Use Cases
  serviceLocator.registerLazySingleton(
          () => CreatePostUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
          () => DeletePostUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
          () => LikePostUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
          () => ReadPostUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
          () => ReadSinglePostUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
          () => UpdatePostUseCase(repository: serviceLocator.call()));
  ///Comment Use Cases
  serviceLocator.registerLazySingleton(
          () => CreateCommentUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
          () => DeleteCommentUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
          () => LikeCommentUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
          () => ReadCommentUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
          () => UpdateCommentUseCase(repository: serviceLocator.call()));
  ///Replay Use Cases
  serviceLocator.registerLazySingleton(
          () => CreateReplayUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
          () => DeleteReplayUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
          () => LikeReplayUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
          () => ReadReplaysUseCase(repository: serviceLocator.call()));
  serviceLocator.registerLazySingleton(
          () => UpdateReplayUseCase(repository: serviceLocator.call()));
  ///Externals
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;
  serviceLocator.registerLazySingleton(() => firebaseFirestore);
  serviceLocator.registerLazySingleton(() => firebaseAuth);
  serviceLocator.registerLazySingleton(() => firebaseStorage);
}
