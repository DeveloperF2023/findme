import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social/constants.dart';
import 'package:social/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:social/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:social/features/presentation/cubit/user/user_cubit.dart';
import 'package:social/features/presentation/pages/Authentication/sign_in_screen.dart';
import 'features/presentation/cubit/auth/auth_cubit.dart';
import 'features/presentation/pages/main_screen/main_screen.dart';
import 'features/presentation/pages/splash/splash_screen.dart';
import 'on_generate_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'injection_container.dart' as injection;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await injection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=> injection.serviceLocator<AuthCubit>()..appStarted(context)),
    BlocProvider(create: (_)=> injection.serviceLocator<CredentialCubit>()),
        BlocProvider(create: (_)=> injection.serviceLocator<UserCubit>()),
        BlocProvider(create: (_)=> injection.serviceLocator<GetSingleUserCubit>()),
      ],
      child: MaterialApp(
        builder: FToastBuilder(),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: OnGenerateRoute.route,
        initialRoute: "/",
        routes: {
          "/": (context) => BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  if (authState is Authenticated) {
                    return MainScreen(
                      uid: authState.uid,
                    );
                  } else {
                    return const SignInScreen();
                  }
                },
              )
        },
      ),
    );
  }
}
