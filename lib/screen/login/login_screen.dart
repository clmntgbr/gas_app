import '../base/base_screen.dart';
import '../signup/signup_screen.dart';
import '../../service/api_service.dart';
import '../../service/login_service.dart';
import '../../service/password_validator.dart';
import '../../widget/input_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final loginService = LoginService();
  final apiService = ApiService();
  bool isLoading = false;
  String errorMessage = '';
  late Future<bool> isTokenValid;
  Color emailFillColor = const Color(0xFFF2F3F8);
  Color passwordFillColor = const Color(0xFFF2F3F8);

  void _login(BuildContext context) async {
    setState(
      () => (isLoading = true, errorMessage = ''),
    );
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    final bool isEmailValid = EmailValidator.validate(email);
    final bool isPasswordValid = PasswordValidator.validate(password);

    if (!isEmailValid) {
      setState(
        () => (
          isLoading = false,
          emailFillColor = const Color.fromARGB(255, 249, 207, 204),
        ),
      );
    }

    if (isEmailValid) {
      setState(
        () => (
          isLoading = true,
          emailFillColor = const Color(0xFFF2F3F8),
        ),
      );
    }

    if (!isPasswordValid) {
      setState(
        () => (
          isLoading = false,
          passwordFillColor = const Color.fromARGB(255, 249, 207, 204),
        ),
      );
    }

    if (isPasswordValid) {
      setState(
        () => (
          isLoading = true,
          passwordFillColor = const Color(0xFFF2F3F8),
        ),
      );
    }

    if (!isPasswordValid || !isEmailValid) {
      return;
    }

    final response = await loginService.login(email, password);
    await loginService.loginStorage(response);

    setState(() => isLoading = false);

    if (response['code'] == 200) {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BaseScreen(),
          ),
        );
      }
    } else {
      setState(() => errorMessage = response['message']);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /** for tests */
    emailController.text = 'clement@gmail.com';
    passwordController.text = 'clement';

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFF2F3F8),
        body: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(0, 600, 0, 0),
          shrinkWrap: true,
          reverse: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: HexColor("#ffffff"),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Log In",
                              style: GoogleFonts.poppins(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: HexColor("#4f4f4f"),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: HexColor("#8d8d8d"),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InputField(
                                    fillColor: emailFillColor,
                                    controller: emailController,
                                    hintText: "hello@gmail.com",
                                    obscureText: false,
                                    prefixIcon: const Icon(Icons.mail_outline),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Mot de passe",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: HexColor("#8d8d8d"),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InputField(
                                    fillColor: passwordFillColor,
                                    controller: passwordController,
                                    hintText: "**************",
                                    obscureText: true,
                                    prefixIcon: const Icon(Icons.lock_outline),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                    height: 58,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xff132137),
                                    ),
                                    child: InkWell(
                                      key: const ValueKey('SignIn button'),
                                      onTap: () {
                                        isLoading ? null : _login(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Connexion',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            isLoading
                                                ? Container(
                                                    width: 20,
                                                    height: 20,
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: const CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 3,
                                                    ),
                                                  )
                                                : const Icon(
                                                    Icons.login,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            errorMessage,
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(255, 245, 74, 62),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Pas de compte ?",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: HexColor("#8d8d8d"),
                                          ),
                                        ),
                                        TextButton(
                                          child: Text(
                                            "Créer mon compte",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor("#44564a"),
                                            ),
                                          ),
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const SignupScreen(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -253),
                      child: Image.asset(
                        'assets/login/login_logo.png',
                        scale: 1.5,
                        width: double.infinity,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
