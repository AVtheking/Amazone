import 'package:amazon_clone/common/widgets/custom_text_widget.dart';
import 'package:amazon_clone/common/widgets/sign_up_button.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Auth { signIn, signUp }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final signInKey = GlobalKey<FormState>();
  final signUpKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signUpUser(BuildContext context) {
    _authService.signUpUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text);
  }

  void signInUser(BuildContext context) {
    _authService.signInUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
        ref: ref);
  }

  Auth _auth = Auth.signUp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            ListTile(
              tileColor: _auth == Auth.signUp
                  ? GlobalVariables.backgroundColor
                  : GlobalVariables.greyBackgroundCOlor,
              title: const Text("Create an account"),
              leading: Radio(
                value: Auth.signUp,
                groupValue: _auth,
                onChanged: (Auth? value) {
                  setState(() {
                    _auth = value!;
                  });
                },
              ),
            ),
            if (_auth == Auth.signUp)
              Form(
                key: signUpKey,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: "Name",
                        controller: _nameController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        hintText: "Email",
                        controller: _emailController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        hintText: "Password",
                        isPass: true,
                        controller: _passwordController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SignUpButton(
                          color: GlobalVariables.secondaryColor,
                          onTap: () {
                            if (signUpKey.currentState!.validate()) {
                              signUpUser(context);
                            }
                          },
                          text: "Sign Up")
                    ],
                  ),
                ),
              ),
            ListTile(
              tileColor: _auth == Auth.signIn
                  ? GlobalVariables.backgroundColor
                  : GlobalVariables.greyBackgroundCOlor,
              title: const Text("Sign-In."),
              leading: Radio(
                value: Auth.signIn,
                groupValue: _auth,
                onChanged: (Auth? value) {
                  setState(() {
                    _auth = value!;
                  });
                },
              ),
            ),
            if (_auth == Auth.signIn)
              Form(
                key: signUpKey,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        hintText: "Email",
                        controller: _emailController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        isPass: true,
                        hintText: "Password",
                        controller: _passwordController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SignUpButton(
                          color: GlobalVariables.secondaryColor,
                          onTap: () {
                            signInUser(context);
                          },
                          text: "Sign In")
                    ],
                  ),
                ),
              ),
          ],
        ),
      )),
    );
  }
}
