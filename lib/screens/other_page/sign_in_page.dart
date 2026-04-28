import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Sign In"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const WelcomeText(
                title: "Welcome to",
                text:
                    "Enter username and password to login",
              ),

              const SignInForm(),

              const SizedBox(height: 16),

              Center(
                child: Text.rich(
                  TextSpan(
                    text:
                        "Don’t have account? ",
                    children: [
                      TextSpan(
                        text:
                            "Create new account",
                        style:
                            const TextStyle(
                          color: Color(
                              0xFF22A45D),
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap =
                                  () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================
// WELCOME TEXT
// ======================================
class WelcomeText extends StatelessWidget {
  final String title, text;

  const WelcomeText({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(
      BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style:
              const TextStyle(
            fontSize: 24,
            fontWeight:
                FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(text),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ======================================
// FORM LOGIN
// ======================================
class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() =>
      _SignInFormState();
}

class _SignInFormState
    extends State<SignInForm> {
  final _formKey =
      GlobalKey<FormState>();

  final usernameController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool isLoading = false;
  bool obscure = true;

  // ======================================
  // LOGIN FUNCTION
  // ======================================
  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    final url =
        "https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok1/food-delivery/login";

    try {
      final response =
          await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/json",
        },
        body: jsonEncode({
          "username":
              usernameController.text,
          "password":
              passwordController.text,
        }),
      );

      final data =
          jsonDecode(response.body);

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            data["message"],
          ),
        ),
      );

      // TOKEN
      print(data["token"]);
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(
      BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // USERNAME
          TextFormField(
            controller:
                usernameController,
            decoration:
                const InputDecoration(
              hintText:
                  "Username",
            ),
          ),

          const SizedBox(
              height: 16),

          // PASSWORD
          TextFormField(
            controller:
                passwordController,
            obscureText:
                obscure,
            decoration:
                InputDecoration(
              hintText:
                  "Password",
              suffixIcon:
                  IconButton(
                onPressed: () {
                  setState(() {
                    obscure =
                        !obscure;
                  });
                },
                icon: Icon(
                  obscure
                      ? Icons
                          .visibility_off
                      : Icons
                          .visibility,
                ),
              ),
            ),
          ),

          const SizedBox(
              height: 20),

          // BUTTON LOGIN
          SizedBox(
            width:
                double.infinity,
            child:
                ElevatedButton(
              onPressed:
                  isLoading
                      ? null
                      : login,
              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    const Color(
                        0xFF22A45D),
              ),
              child:
                  isLoading
                      ? const CircularProgressIndicator(
                          color: Colors
                              .white,
                        )
                      : const Text(
                          "Sign In",
                        ),
            ),
          ),
        ],
      ),
    );
  }
}