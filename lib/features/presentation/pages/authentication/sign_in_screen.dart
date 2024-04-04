import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/constants.dart';
import 'package:social/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:social/features/presentation/widgets/button_container.dart';
import 'package:social/features/presentation/widgets/form_container.dart';
import '../../../../strings.dart';
import '../../cubit/auth/auth_cubit.dart';
import '../main_screen/main_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isSigningIn = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<CredentialCubit, CredentialState>(
          listener: (context, credentialState) {
            if (credentialState is CredentialSuccess) {
              BlocProvider.of<AuthCubit>(context).loggedIn();
            }
            if (credentialState is CredentialFailure) {
              //toast("Invalid email or password",EvaIcons.alertCircleOutline,Colors.red);
              print('Invalid email or password');
            }
          },
          builder: (context, credentialState) {
            if (credentialState is CredentialSuccess) {
              return BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                if (authState is Authenticated) {
                  return MainScreen(
                    uid: authState.uid,
                  );
                } else {
                  return _bodyWidget();
                }
              });
            }
            return _bodyWidget();
          },
        ));
  }

  _bodyWidget() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .2),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .15,
                child: const Center(
                    child: Text(
                  "FindMe.",
                  style: TextStyle(
                      fontFamily: "DancingScript",
                      fontSize: 55,
                      fontWeight: FontWeight.w900,
                      color: primary),
                )),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: Column(
                  children: [
                    Text(
                      AppStrings.signin_text,
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: grey400,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    sizeVertical(20),
                    FormContainer(
                      controller: emailController,
                      hintText: "Email",
                      prefixIcon: Icons.mail,
                    ),
                    sizeVertical(10),
                    FormContainer(
                      controller: passwordController,
                      hintText: "Password",
                      isPasswordField: true,
                      prefixIcon: Icons.lock,
                    ),
                    sizeVertical(20),
                    ButtonContainer(
                      text: "SIGN IN",
                      onTapListener: () {
                        _signInUser();
                      },
                      color: primary.withOpacity(0.8),
                    ),
                    sizeVertical(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.signup_text,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: grey400,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        sizeHorizontal(5),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, NavigationStrings.signUp);
                          },
                          child: Text(
                            AppStrings.signup,
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: primary.withOpacity(0.6),
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 170),
                      child: Column(
                        children: [
                          Text(
                            "By continuing you agree FindMe Terms of",
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w400,
                                color: grey400,
                                fontSize: 13),
                          ),
                          Text(
                            "Services & Privacy Policy",
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w400,
                                color: grey400,
                                fontSize: 13),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signInUser() {
    setState(() {
      _isSigningIn = true;
    });
    BlocProvider.of<CredentialCubit>(context)
        .signInUser(
          email: emailController.text,
          password: passwordController.text,
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      emailController.clear();
      passwordController.clear();
      _isSigningIn = false;
    });
  }
}
